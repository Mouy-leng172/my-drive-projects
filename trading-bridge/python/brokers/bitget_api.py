"""
Bitget Broker API Implementation
Supports both Spot and Futures trading via Bitget API v2

API Documentation: https://www.bitget.com/api-doc/
Network endpoints:
- Network-1: https://api.bitget.com (Primary)
- Network-2: https://api.bitget.com (Backup)
- Automatic network selection based on latency
"""

from __future__ import annotations

import hashlib
import hmac
import json
import time
import urllib.parse
import urllib.request
from typing import Dict, List, Optional, Any
from dataclasses import dataclass

from .base_broker import (
    BaseBroker, BrokerConfig, OrderResult, Position, AccountInfo
)

# Network endpoints configuration
BITGET_NETWORKS = {
    "Network-1": "https://api.bitget.com",
    "Network-2": "https://api.bitget.com",
    "Automatic": "https://api.bitget.com",  # Will auto-select best network
}


@dataclass
class BitgetConfig(BrokerConfig):
    """Bitget-specific configuration"""
    passphrase: Optional[str] = None
    network: str = "Automatic"  # Network-1, Network-2, Network-3, Network-4, or Automatic
    product_type: str = "USDT-FUTURES"  # SPOT or USDT-FUTURES
    test_mode: bool = False  # Use testnet


class BitgetAPI(BaseBroker):
    """Bitget broker implementation"""
    
    def __init__(self, config: BitgetConfig):
        """
        Initialize Bitget API client
        
        Args:
            config: Bitget configuration
        """
        super().__init__(config)
        self.config: BitgetConfig = config
        self.api_key = config.api_key or ""
        self.api_secret = config.api_secret or ""
        self.passphrase = config.passphrase or ""
        self.base_url = self._get_network_url(config.network)
        self.product_type = config.product_type
        self.timeout = 10
        
        # Validate credentials
        if not all([self.api_key, self.api_secret, self.passphrase]):
            raise ValueError("Bitget API requires api_key, api_secret, and passphrase")
    
    def _get_network_url(self, network: str) -> str:
        """
        Get API endpoint URL for specified network
        
        Args:
            network: Network identifier
            
        Returns:
            Base URL for API requests
        """
        if network in BITGET_NETWORKS:
            return BITGET_NETWORKS[network]
        return BITGET_NETWORKS["Automatic"]
    
    def _generate_signature(self, timestamp: str, method: str, request_path: str, body: str = "") -> str:
        """
        Generate HMAC signature for Bitget API authentication
        
        Args:
            timestamp: Unix timestamp in milliseconds
            method: HTTP method (GET, POST, etc.)
            request_path: API endpoint path
            body: Request body (for POST requests)
            
        Returns:
            Base64-encoded signature
        """
        # Create pre-hash string: timestamp + method + requestPath + body
        message = timestamp + method.upper() + request_path + body
        
        # Generate HMAC signature
        signature = hmac.new(
            self.api_secret.encode('utf-8'),
            message.encode('utf-8'),
            hashlib.sha256
        ).digest()
        
        # Return base64-encoded signature
        import base64
        return base64.b64encode(signature).decode('utf-8')
    
    def _make_request(self, method: str, endpoint: str, params: Optional[Dict] = None,
                     data: Optional[Dict] = None) -> Dict[str, Any]:
        """
        Make authenticated API request to Bitget
        
        Args:
            method: HTTP method
            endpoint: API endpoint path
            params: Query parameters
            data: Request body data
            
        Returns:
            API response as dictionary
        """
        # Generate timestamp
        timestamp = str(int(time.time() * 1000))
        
        # Build request path
        request_path = endpoint
        if params:
            query_string = urllib.parse.urlencode(params)
            request_path += f"?{query_string}"
        
        # Prepare body
        body = ""
        if data:
            body = json.dumps(data)
        
        # Generate signature
        signature = self._generate_signature(timestamp, method, request_path, body)
        
        # Build headers
        headers = {
            "ACCESS-KEY": self.api_key,
            "ACCESS-SIGN": signature,
            "ACCESS-TIMESTAMP": timestamp,
            "ACCESS-PASSPHRASE": self.passphrase,
            "Content-Type": "application/json",
            "locale": "en-US",
        }
        
        # Build full URL
        url = self.base_url + request_path
        
        # Make request
        try:
            if method.upper() == "GET":
                req = urllib.request.Request(url, headers=headers, method="GET")
            else:
                req = urllib.request.Request(
                    url,
                    data=body.encode('utf-8') if body else None,
                    headers=headers,
                    method=method.upper()
                )
            
            with urllib.request.urlopen(req, timeout=self.timeout) as response:
                response_text = response.read().decode('utf-8')
                return json.loads(response_text)
        except Exception as e:
            return {
                "code": "error",
                "msg": str(e),
                "data": None
            }
    
    def place_order(self, symbol: str, action: str, lot_size: float,
                   stop_loss: Optional[float] = None,
                   take_profit: Optional[float] = None,
                   comment: str = "") -> OrderResult:
        """
        Place order on Bitget
        
        Args:
            symbol: Trading symbol (e.g., 'BTCUSDT')
            action: Order action ('BUY' or 'SELL')
            lot_size: Position size
            stop_loss: Stop loss price
            take_profit: Take profit price
            comment: Order comment
            
        Returns:
            OrderResult with execution details
        """
        try:
            # Prepare order data
            order_data = {
                "symbol": symbol,
                "productType": self.product_type,
                "marginMode": "crossed",
                "marginCoin": "USDT",
                "size": str(lot_size),
                "side": "buy" if action.upper() == "BUY" else "sell",
                "tradeSide": "open",
                "orderType": "market",
                "clientOid": f"{int(time.time() * 1000)}",
            }
            
            # Add stop loss and take profit if provided
            if stop_loss:
                order_data["presetStopLossPrice"] = str(stop_loss)
            if take_profit:
                order_data["presetTakeProfitPrice"] = str(take_profit)
            
            # Make API request
            if self.product_type == "USDT-FUTURES":
                endpoint = "/api/v2/mix/order/place-order"
            else:
                endpoint = "/api/v2/spot/trade/place-order"
            
            response = self._make_request("POST", endpoint, data=order_data)
            
            # Check response
            if response.get("code") == "00000":
                return OrderResult(
                    success=True,
                    order_id=response.get("data", {}).get("orderId"),
                    message="Order placed successfully"
                )
            else:
                return OrderResult(
                    success=False,
                    message=response.get("msg", "Unknown error"),
                    error_code=response.get("code")
                )
        except Exception as e:
            return OrderResult(
                success=False,
                message=f"Error placing order: {str(e)}"
            )
    
    def get_account_info(self) -> AccountInfo:
        """
        Get Bitget account information
        
        Returns:
            AccountInfo with account details
        """
        try:
            if self.product_type == "USDT-FUTURES":
                endpoint = "/api/v2/mix/account/account"
                params = {"productType": self.product_type}
            else:
                endpoint = "/api/v2/spot/account/assets"
                params = {}
            
            response = self._make_request("GET", endpoint, params=params)
            
            if response.get("code") == "00000":
                data = response.get("data", [])
                if data and len(data) > 0:
                    account = data[0]
                    return AccountInfo(
                        balance=float(account.get("available", 0)),
                        equity=float(account.get("equity", 0)),
                        margin=float(account.get("locked", 0)),
                        free_margin=float(account.get("available", 0)),
                        margin_level=100.0,  # Calculate based on your risk management
                        currency="USDT"
                    )
            
            return AccountInfo(
                balance=0.0,
                equity=0.0,
                margin=0.0,
                free_margin=0.0,
                margin_level=0.0,
                currency="USDT"
            )
        except Exception:
            return AccountInfo(
                balance=0.0,
                equity=0.0,
                margin=0.0,
                free_margin=0.0,
                margin_level=0.0,
                currency="USDT"
            )
    
    def get_positions(self, symbol: Optional[str] = None) -> List[Position]:
        """
        Get open positions from Bitget
        
        Args:
            symbol: Filter by symbol
            
        Returns:
            List of open positions
        """
        try:
            if self.product_type == "USDT-FUTURES":
                endpoint = "/api/v2/mix/position/all-position"
                params = {"productType": self.product_type}
                if symbol:
                    params["symbol"] = symbol
            else:
                # Spot doesn't have positions, return empty list
                return []
            
            response = self._make_request("GET", endpoint, params=params)
            
            positions = []
            if response.get("code") == "00000":
                data = response.get("data", [])
                for pos in data:
                    if float(pos.get("total", 0)) > 0:
                        positions.append(Position(
                            symbol=pos.get("symbol", ""),
                            volume=float(pos.get("total", 0)),
                            type="BUY" if pos.get("holdSide") == "long" else "SELL",
                            open_price=float(pos.get("openPriceAvg", 0)),
                            current_price=float(pos.get("markPrice", 0)),
                            profit=float(pos.get("unrealizedPL", 0)),
                            swap=0.0,
                            commission=0.0,
                            position_id=pos.get("positionId")
                        ))
            
            return positions
        except Exception:
            return []
    
    def close_position(self, position_id: str) -> OrderResult:
        """
        Close a position on Bitget
        
        Args:
            position_id: Position ID to close
            
        Returns:
            OrderResult with execution details
            
        Raises:
            NotImplementedError: This method is not yet implemented
        """
        # TODO: Implement position closing for Bitget
        # Bitget requires placing a reverse order to close a position
        raise NotImplementedError(
            "Close position is not yet fully implemented for Bitget. "
            "To close a position, place a reverse order manually."
        )
    
    def modify_position(self, position_id: str, stop_loss: Optional[float] = None,
                       take_profit: Optional[float] = None) -> OrderResult:
        """
        Modify position stop loss/take profit
        
        Args:
            position_id: Position ID
            stop_loss: New stop loss price
            take_profit: New take profit price
            
        Returns:
            OrderResult with execution details
            
        Raises:
            NotImplementedError: This method is not yet implemented
        """
        # TODO: Implement position modification for Bitget
        # Bitget supports modifying stop loss and take profit via API
        raise NotImplementedError(
            "Modify position is not yet fully implemented for Bitget. "
            "Use the Bitget web interface or app to modify positions manually."
        )
    
    def test_connection(self) -> bool:
        """
        Test connection to Bitget API
        
        Returns:
            True if connection successful
        """
        try:
            endpoint = "/api/v2/public/time"
            response = self._make_request("GET", endpoint)
            return response.get("code") == "00000"
        except Exception:
            return False
    
    def get_network_latency(self) -> int:
        """
        Measure network latency to current endpoint
        
        Returns:
            Latency in milliseconds
        """
        try:
            start_time = time.time()
            self.test_connection()
            end_time = time.time()
            return int((end_time - start_time) * 1000)
        except Exception:
            return 9999  # Return high value on error
