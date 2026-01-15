"""
Example Trading Bridge API Client
Demonstrates how to interact with the Trading Bridge FastAPI
"""
import os
import sys
import requests
from typing import Dict, Any, Optional
from datetime import datetime


class TradingBridgeClient:
    """Client for interacting with Trading Bridge API"""
    
    def __init__(self, base_url: str = "http://localhost:8000", api_key: Optional[str] = None):
        """
        Initialize Trading Bridge client
        
        Args:
            base_url: API base URL
            api_key: API key for authentication
        """
        self.base_url = base_url.rstrip('/')
        self.api_key = api_key or os.getenv('TRADING_BRIDGE_API_KEY')
        
        if not self.api_key:
            print("Warning: No API key provided. Set TRADING_BRIDGE_API_KEY environment variable.")
        
        self.headers = {
            'X-API-Key': self.api_key,
            'Content-Type': 'application/json'
        }
    
    def check_health(self) -> Dict[str, Any]:
        """Check API health status"""
        response = requests.get(f"{self.base_url}/health")
        response.raise_for_status()
        return response.json()
    
    def get_bridge_status(self) -> Dict[str, Any]:
        """Get MQL5 bridge status"""
        response = requests.get(
            f"{self.base_url}/bridge/status",
            headers=self.headers
        )
        response.raise_for_status()
        return response.json()
    
    def submit_signal(
        self,
        symbol: str,
        broker: str,
        action: str,
        lot_size: float,
        stop_loss: Optional[float] = None,
        take_profit: Optional[float] = None,
        comment: str = ""
    ) -> Dict[str, Any]:
        """
        Submit a trade signal
        
        Args:
            symbol: Trading symbol (e.g., "EURUSD")
            broker: Broker name (e.g., "EXNESS")
            action: Trade action ("BUY", "SELL", or "CLOSE")
            lot_size: Lot size
            stop_loss: Stop loss price (optional)
            take_profit: Take profit price (optional)
            comment: Trade comment (optional)
        
        Returns:
            Response dictionary with success status and signal ID
        """
        signal = {
            'symbol': symbol,
            'broker': broker,
            'action': action.upper(),
            'lot_size': lot_size,
            'comment': comment
        }
        
        if stop_loss is not None:
            signal['stop_loss'] = stop_loss
        
        if take_profit is not None:
            signal['take_profit'] = take_profit
        
        response = requests.post(
            f"{self.base_url}/signals",
            json=signal,
            headers=self.headers
        )
        response.raise_for_status()
        return response.json()
    
    def get_queue_status(self) -> Dict[str, Any]:
        """Get signal queue status"""
        response = requests.get(
            f"{self.base_url}/signals/queue",
            headers=self.headers
        )
        response.raise_for_status()
        return response.json()


def main():
    """Example usage"""
    # Initialize client
    client = TradingBridgeClient()
    
    print("=" * 60)
    print("Trading Bridge API Client - Example")
    print("=" * 60)
    print()
    
    # Check health
    print("1. Checking API health...")
    try:
        health = client.check_health()
        print(f"   Status: {health['status']}")
        print(f"   Bridge Connected: {health['bridge_connected']}")
        print(f"   Timestamp: {health['timestamp']}")
    except Exception as e:
        print(f"   Error: {e}")
        sys.exit(1)
    
    print()
    
    # Get bridge status
    print("2. Getting bridge status...")
    try:
        status = client.get_bridge_status()
        print(f"   Connection: {status['connection_status']}")
        print(f"   Queue Size: {status['queue_size']}")
        print(f"   Signals Sent: {status['stats']['signals_sent']}")
        print(f"   Errors: {status['stats']['errors']}")
    except Exception as e:
        print(f"   Error: {e}")
        sys.exit(1)
    
    print()
    
    # Submit a test signal
    print("3. Submitting test signal...")
    try:
        result = client.submit_signal(
            symbol="EURUSD",
            broker="EXNESS",
            action="BUY",
            lot_size=0.01,
            stop_loss=1.0850,
            take_profit=1.0950,
            comment="Example client test signal"
        )
        print(f"   Success: {result['success']}")
        print(f"   Message: {result['message']}")
        print(f"   Signal ID: {result.get('signal_id', 'N/A')}")
    except Exception as e:
        print(f"   Error: {e}")
    
    print()
    
    # Get queue status
    print("4. Checking queue status...")
    try:
        queue = client.get_queue_status()
        print(f"   Current Queue Size: {queue['queue_size']}")
        print(f"   Max Queue Size: {queue['max_queue_size']}")
    except Exception as e:
        print(f"   Error: {e}")
    
    print()
    print("=" * 60)
    print("Example completed successfully!")
    print("=" * 60)


if __name__ == "__main__":
    main()
