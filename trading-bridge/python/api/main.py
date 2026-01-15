"""
FastAPI Main Application
REST API for Trading Bridge system with API key authentication
"""
import os
import logging
from datetime import datetime
from typing import Optional, Dict, Any, List
from pathlib import Path
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException, Depends, Security, status
from fastapi.security import APIKeyHeader
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

# Import bridge components
import sys
sys.path.insert(0, str(Path(__file__).parent.parent))
from bridge.mql5_bridge import MQL5Bridge
from bridge.signal_manager import TradeSignal

# Setup logging
log_dir = Path(__file__).parent.parent.parent / "logs"
log_dir.mkdir(parents=True, exist_ok=True)
log_file = log_dir / f"fastapi_{datetime.now().strftime('%Y%m%d')}.log"

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(log_file, encoding='utf-8'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)

# API Key authentication
API_KEY_NAME = "X-API-Key"
api_key_header = APIKeyHeader(name=API_KEY_NAME, auto_error=False)

# Load API key from environment variable
API_KEY = os.getenv("TRADING_BRIDGE_API_KEY")

# Production mode check
PRODUCTION_MODE = os.getenv("PRODUCTION_MODE", "false").lower() == "true"

if not API_KEY:
    if PRODUCTION_MODE:
        logger.error("TRADING_BRIDGE_API_KEY not set in production mode!")
        raise ValueError("API key must be set in production mode. Set TRADING_BRIDGE_API_KEY environment variable.")
    else:
        logger.warning("TRADING_BRIDGE_API_KEY not set! Using INSECURE development key. DO NOT use in production!")
        API_KEY = "INSECURE-dev-key-DO-NOT-USE-IN-PRODUCTION"  # Obviously insecure for development only

# Global bridge instance
bridge: Optional[MQL5Bridge] = None


# Lifespan context manager for startup/shutdown
@asynccontextmanager
async def lifespan(app: FastAPI):
    """Manage application lifespan - startup and shutdown"""
    global bridge
    
    # Startup
    try:
        # Get bridge configuration from environment
        bridge_port = int(os.getenv("BRIDGE_PORT", "5500"))
        bridge_host = os.getenv("BRIDGE_HOST", "127.0.0.1")
        
        logger.info(f"Initializing MQL5 bridge on {bridge_host}:{bridge_port}")
        bridge = MQL5Bridge(port=bridge_port, host=bridge_host)
        
        # Start bridge in background thread
        import threading
        bridge_thread = threading.Thread(target=bridge.start, daemon=True)
        bridge_thread.start()
        
        logger.info("MQL5 bridge initialized successfully")
        
    except Exception as e:
        logger.error(f"Failed to initialize bridge: {e}")
        # Don't fail startup, but bridge won't be available
    
    yield
    
    # Shutdown
    if bridge:
        logger.info("Stopping MQL5 bridge...")
        bridge.stop()
        bridge = None


# FastAPI app with lifespan
app = FastAPI(
    title="Trading Bridge API",
    description="REST API for MQL5 Trading Bridge - Connect to Expert Advisers",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan
)

# CORS middleware - configure for production
# Default to localhost only for security
CORS_ORIGINS = os.getenv("CORS_ORIGINS", "http://localhost:3000,http://localhost:8000").split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=CORS_ORIGINS,  # Specific origins for security
    allow_credentials=False,  # Disabled since API uses X-API-Key header authentication
    allow_methods=["GET", "POST", "PUT", "DELETE"],
    allow_headers=["X-API-Key", "Content-Type"],
)


# Pydantic Models
class HealthResponse(BaseModel):
    """Health check response"""
    status: str
    timestamp: str
    bridge_connected: bool


class BridgeStatusResponse(BaseModel):
    """Bridge status response"""
    connection_status: str
    queue_size: int
    stats: Dict[str, int]
    last_heartbeat: Optional[str]


class SignalRequest(BaseModel):
    """Trade signal request"""
    symbol: str = Field(..., description="Trading symbol (e.g., EURUSD)")
    broker: str = Field(..., description="Broker name (e.g., EXNESS)")
    action: str = Field(..., description="Trade action: BUY, SELL, CLOSE")
    lot_size: float = Field(..., gt=0, description="Lot size")
    stop_loss: Optional[float] = Field(None, description="Stop loss price")
    take_profit: Optional[float] = Field(None, description="Take profit price")
    comment: str = Field("", description="Trade comment")


class SignalResponse(BaseModel):
    """Signal submission response"""
    success: bool
    message: str
    signal_id: Optional[str] = None


# Authentication dependency
async def verify_api_key(api_key: str = Security(api_key_header)) -> str:
    """Verify API key"""
    if api_key is None or api_key != API_KEY:
        logger.warning("Unauthorized API access attempt")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or missing API key"
        )
    return api_key


# Routes
@app.get("/", response_model=Dict[str, str])
async def root():
    """Root endpoint with API information"""
    return {
        "name": "Trading Bridge API",
        "version": "1.0.0",
        "description": "REST API for MQL5 Trading Bridge",
        "docs": "/docs",
        "health": "/health"
    }


@app.get("/health", response_model=HealthResponse)
async def health_check():
    """Health check endpoint - no authentication required"""
    bridge_connected = bridge is not None and bridge.connection_status in ["connected", "listening"]
    
    return HealthResponse(
        status="healthy",
        timestamp=datetime.now().isoformat(),
        bridge_connected=bridge_connected
    )


@app.get("/bridge/status", response_model=BridgeStatusResponse)
async def get_bridge_status(api_key: str = Depends(verify_api_key)):
    """Get MQL5 bridge status - requires authentication"""
    if bridge is None:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Bridge not initialized"
        )
    
    status = bridge.get_status()
    return BridgeStatusResponse(**status)


@app.post("/signals", response_model=SignalResponse)
async def submit_signal(signal_request: SignalRequest, api_key: str = Depends(verify_api_key)):
    """
    Submit a trade signal to the MQL5 bridge - requires authentication
    
    The signal will be queued and picked up by the Expert Adviser
    """
    if bridge is None:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Bridge not initialized"
        )
    
    # Validate action
    valid_actions = ["BUY", "SELL", "CLOSE"]
    if signal_request.action.upper() not in valid_actions:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid action. Must be one of: {', '.join(valid_actions)}"
        )
    
    # Create trade signal
    trade_signal = TradeSignal(
        symbol=signal_request.symbol,
        broker=signal_request.broker,
        action=signal_request.action.upper(),
        lot_size=signal_request.lot_size,
        stop_loss=signal_request.stop_loss,
        take_profit=signal_request.take_profit,
        comment=signal_request.comment
    )
    
    # Submit to bridge
    success, error = bridge.send_signal(trade_signal)
    
    if success:
        # Log only metadata, not sensitive trading details
        logger.info(f"Signal queued: {signal_request.action} {signal_request.symbol} [ID: {trade_signal.signal_id}]")
        return SignalResponse(
            success=True,
            message="Signal queued successfully",
            signal_id=trade_signal.signal_id
        )
    else:
        logger.error(f"Failed to submit signal: {error}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=error or "Failed to queue signal"
        )


@app.get("/signals/queue")
async def get_queue_status(api_key: str = Depends(verify_api_key)):
    """Get signal queue status - requires authentication"""
    if bridge is None:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Bridge not initialized"
        )
    
    return {
        "queue_size": bridge.signal_manager.get_queue_size(),
        "max_queue_size": bridge.signal_manager.max_queue_size
    }


if __name__ == "__main__":
    import uvicorn
    
    # Get configuration from environment
    host = os.getenv("API_HOST", "0.0.0.0")
    port = int(os.getenv("API_PORT", "8000"))
    
    logger.info(f"Starting FastAPI server on {host}:{port}")
    uvicorn.run(app, host=host, port=port)
