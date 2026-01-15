# OpenBB Platform Dockerfile
# 
# This Dockerfile creates a containerized OpenBB Platform service
# for financial data and market analytics
#

FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install OpenBB Platform
# Option 1: Install from PyPI (stable release)
RUN pip install openbb

# Option 2: Install from GitHub (latest development version)
# Uncomment the following line to use the latest development version
# RUN pip install git+https://github.com/OpenBB-finance/OpenBB.git@develop

# Install additional dependencies
RUN pip install \
    fastapi \
    uvicorn[standard] \
    pydantic \
    pyyaml \
    redis \
    sqlalchemy \
    psycopg2-binary \
    python-dotenv

# Create necessary directories
RUN mkdir -p /app/config /app/data /app/logs

# Copy configuration
COPY configs/openbb.yaml /app/config/openbb.yaml

# Create a simple FastAPI wrapper for OpenBB
COPY <<EOF /app/main.py
"""
OpenBB Platform API Server

This server provides a REST API interface to the OpenBB Platform.
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, List
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="OpenBB Platform API",
    description="REST API for OpenBB Platform - Financial Data and Market Analytics",
    version="1.0.0"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Health check endpoint
@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "ok", "service": "OpenBB Platform API"}

# Root endpoint
@app.get("/")
async def root():
    """Root endpoint with API information"""
    return {
        "name": "OpenBB Platform API",
        "version": "1.0.0",
        "status": "running",
        "docs": "/docs"
    }

# Placeholder endpoints (to be implemented with actual OpenBB SDK calls)
@app.get("/api/stocks/historical")
async def get_stock_historical(symbol: str, start_date: Optional[str] = None, end_date: Optional[str] = None):
    """Get historical stock data"""
    logger.info(f"Fetching historical data for {symbol}")
    # TODO: Implement with OpenBB SDK
    return {"symbol": symbol, "message": "Endpoint to be implemented with OpenBB SDK"}

@app.post("/api/market/data")
async def get_market_data(symbols: List[str]):
    """Get market data for multiple symbols"""
    logger.info(f"Fetching market data for {len(symbols)} symbols")
    # TODO: Implement with OpenBB SDK
    return {"symbols": symbols, "message": "Endpoint to be implemented with OpenBB SDK"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
EOF

# Expose port
EXPOSE 8000

# Run the application
CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
