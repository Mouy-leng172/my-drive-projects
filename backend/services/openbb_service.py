"""
OpenBB Service - Financial Data and Market Analytics Integration

This service provides an interface to the OpenBB Platform for:
- Financial data retrieval
- Market analytics
- Research tools
- Economic indicators

Usage:
    from backend.services.openbb_service import OpenBBService
    
    service = OpenBBService()
    data = service.get_stock_data(symbol="AAPL")
"""

import logging
import requests
from typing import Dict, List, Optional, Any
from datetime import datetime, timedelta

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class OpenBBService:
    """
    Service class for interacting with OpenBB API/SDK
    
    This class handles all interactions with the OpenBB analytics engine,
    providing methods for financial data retrieval and market analysis.
    """
    
    def __init__(self, base_url: str = "http://localhost:8000", api_key: Optional[str] = None):
        """
        Initialize OpenBB Service
        
        Args:
            base_url: Base URL for OpenBB API service (default: localhost:8000)
            api_key: Optional API key for authentication
        """
        self.base_url = base_url.rstrip('/')
        self.api_key = api_key
        self.session = requests.Session()
        
        if api_key:
            self.session.headers.update({"Authorization": f"Bearer {api_key}"})
        
        logger.info(f"OpenBB Service initialized with base_url: {self.base_url}")
    
    def _make_request(self, endpoint: str, method: str = "GET", **kwargs) -> Dict[str, Any]:
        """
        Make HTTP request to OpenBB API
        
        Args:
            endpoint: API endpoint (without base URL)
            method: HTTP method (GET, POST, etc.)
            **kwargs: Additional arguments for requests
            
        Returns:
            Response data as dictionary
        """
        url = f"{self.base_url}/{endpoint.lstrip('/')}"
        
        try:
            response = self.session.request(method, url, **kwargs)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            logger.error(f"Request to {url} failed: {e}")
            raise
    
    def get_stock_data(self, symbol: str, start_date: Optional[str] = None, 
                       end_date: Optional[str] = None) -> Dict[str, Any]:
        """
        Retrieve stock data for a given symbol
        
        Args:
            symbol: Stock ticker symbol (e.g., "AAPL", "MSFT")
            start_date: Start date in YYYY-MM-DD format (optional)
            end_date: End date in YYYY-MM-DD format (optional)
            
        Returns:
            Dictionary containing stock data
        """
        params = {"symbol": symbol}
        if start_date:
            params["start_date"] = start_date
        if end_date:
            params["end_date"] = end_date
        
        logger.info(f"Fetching stock data for {symbol}")
        return self._make_request("/api/stocks/historical", params=params)
    
    def get_market_data(self, symbols: List[str]) -> Dict[str, Any]:
        """
        Retrieve market data for multiple symbols
        
        Args:
            symbols: List of ticker symbols
            
        Returns:
            Dictionary containing market data for all symbols
        """
        logger.info(f"Fetching market data for {len(symbols)} symbols")
        return self._make_request("/api/market/data", method="POST", json={"symbols": symbols})
    
    def get_economic_indicators(self, indicator: str, country: str = "US") -> Dict[str, Any]:
        """
        Retrieve economic indicators
        
        Args:
            indicator: Type of indicator (e.g., "GDP", "inflation", "unemployment")
            country: Country code (default: "US")
            
        Returns:
            Dictionary containing economic indicator data
        """
        logger.info(f"Fetching {indicator} data for {country}")
        return self._make_request(f"/api/economy/{indicator}", params={"country": country})
    
    def get_company_info(self, symbol: str) -> Dict[str, Any]:
        """
        Retrieve company information
        
        Args:
            symbol: Stock ticker symbol
            
        Returns:
            Dictionary containing company information
        """
        logger.info(f"Fetching company info for {symbol}")
        return self._make_request(f"/api/stocks/info/{symbol}")
    
    def get_technical_indicators(self, symbol: str, indicator: str, 
                                 period: int = 14) -> Dict[str, Any]:
        """
        Calculate technical indicators
        
        Args:
            symbol: Stock ticker symbol
            indicator: Technical indicator (e.g., "RSI", "MACD", "SMA")
            period: Period for calculation (default: 14)
            
        Returns:
            Dictionary containing technical indicator data
        """
        logger.info(f"Calculating {indicator} for {symbol} with period {period}")
        return self._make_request(
            f"/api/technical/{indicator}",
            params={"symbol": symbol, "period": period}
        )
    
    def search_symbols(self, query: str, limit: int = 10) -> List[Dict[str, Any]]:
        """
        Search for ticker symbols
        
        Args:
            query: Search query string
            limit: Maximum number of results (default: 10)
            
        Returns:
            List of matching symbols with metadata
        """
        logger.info(f"Searching symbols with query: {query}")
        response = self._make_request(
            "/api/search",
            params={"q": query, "limit": limit}
        )
        return response.get("results", [])
    
    def health_check(self) -> bool:
        """
        Check if OpenBB service is healthy and responding
        
        Returns:
            True if service is healthy, False otherwise
        """
        try:
            response = self._make_request("/health")
            return response.get("status") == "ok"
        except Exception as e:
            logger.error(f"Health check failed: {e}")
            return False


# Example usage
if __name__ == "__main__":
    # Initialize service
    service = OpenBBService()
    
    # Check health
    if service.health_check():
        print("✓ OpenBB service is healthy")
        
        # Example: Get stock data
        try:
            data = service.get_stock_data("AAPL")
            print(f"✓ Retrieved data for AAPL: {len(data)} records")
        except Exception as e:
            print(f"✗ Failed to retrieve stock data: {e}")
    else:
        print("✗ OpenBB service is not available")
