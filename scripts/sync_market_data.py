#!/usr/bin/env python3
"""
Market Data Synchronization Script

This script synchronizes market data from OpenBB Platform to local storage.
It can be run manually or scheduled via cron/Task Scheduler.

Usage:
    python sync_market_data.py [--symbols AAPL,MSFT] [--days 30]
"""

import argparse
import logging
import sys
import os
from datetime import datetime, timedelta
from typing import List, Optional
import json

# Add parent directory to path to import backend modules
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from backend.services.openbb_service import OpenBBService

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('logs/sync_market_data.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)


class MarketDataSynchronizer:
    """
    Synchronizes market data from OpenBB to local storage
    """
    
    def __init__(self, openbb_service: OpenBBService, output_dir: str = "data/market"):
        """
        Initialize synchronizer
        
        Args:
            openbb_service: OpenBB service instance
            output_dir: Directory to store synchronized data
        """
        self.service = openbb_service
        self.output_dir = output_dir
        
        # Create output directory if it doesn't exist
        os.makedirs(output_dir, exist_ok=True)
        
        logger.info(f"Market Data Synchronizer initialized with output_dir: {output_dir}")
    
    def sync_stock_data(self, symbols: List[str], days: int = 30) -> dict:
        """
        Synchronize stock data for given symbols
        
        Args:
            symbols: List of stock ticker symbols
            days: Number of days of historical data to fetch
            
        Returns:
            Dictionary with sync results
        """
        results = {
            "timestamp": datetime.now().isoformat(),
            "symbols": [],
            "success_count": 0,
            "error_count": 0,
            "errors": []
        }
        
        end_date = datetime.now()
        start_date = end_date - timedelta(days=days)
        
        logger.info(f"Syncing {len(symbols)} symbols for {days} days")
        
        for symbol in symbols:
            try:
                logger.info(f"Fetching data for {symbol}")
                
                # Fetch stock data
                data = self.service.get_stock_data(
                    symbol=symbol,
                    start_date=start_date.strftime('%Y-%m-%d'),
                    end_date=end_date.strftime('%Y-%m-%d')
                )
                
                # Save to file
                output_file = os.path.join(
                    self.output_dir,
                    f"{symbol}_{datetime.now().strftime('%Y%m%d')}.json"
                )
                
                with open(output_file, 'w') as f:
                    json.dump(data, f, indent=2)
                
                results["symbols"].append({
                    "symbol": symbol,
                    "status": "success",
                    "file": output_file,
                    "records": len(data) if isinstance(data, list) else 1
                })
                
                results["success_count"] += 1
                logger.info(f"✓ Successfully synced {symbol} to {output_file}")
                
            except Exception as e:
                error_msg = f"Failed to sync {symbol}: {str(e)}"
                logger.error(error_msg)
                
                results["symbols"].append({
                    "symbol": symbol,
                    "status": "error",
                    "error": str(e)
                })
                
                results["errors"].append(error_msg)
                results["error_count"] += 1
        
        return results
    
    def sync_market_overview(self) -> dict:
        """
        Synchronize general market overview data
        
        Returns:
            Dictionary with sync results
        """
        logger.info("Syncing market overview")
        
        try:
            # Fetch major indices
            indices = ["SPY", "QQQ", "DIA"]
            data = self.service.get_market_data(indices)
            
            # Save to file
            output_file = os.path.join(
                self.output_dir,
                f"market_overview_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
            )
            
            with open(output_file, 'w') as f:
                json.dump(data, f, indent=2)
            
            logger.info(f"✓ Market overview synced to {output_file}")
            
            return {
                "status": "success",
                "file": output_file,
                "timestamp": datetime.now().isoformat()
            }
            
        except Exception as e:
            error_msg = f"Failed to sync market overview: {str(e)}"
            logger.error(error_msg)
            return {
                "status": "error",
                "error": str(e),
                "timestamp": datetime.now().isoformat()
            }
    
    def cleanup_old_data(self, days: int = 7) -> dict:
        """
        Clean up data files older than specified days
        
        Args:
            days: Files older than this many days will be deleted
            
        Returns:
            Dictionary with cleanup results
        """
        logger.info(f"Cleaning up data files older than {days} days")
        
        cutoff_date = datetime.now() - timedelta(days=days)
        deleted_count = 0
        errors = []
        
        try:
            for filename in os.listdir(self.output_dir):
                filepath = os.path.join(self.output_dir, filename)
                
                if os.path.isfile(filepath):
                    file_mtime = datetime.fromtimestamp(os.path.getmtime(filepath))
                    
                    if file_mtime < cutoff_date:
                        try:
                            os.remove(filepath)
                            deleted_count += 1
                            logger.info(f"Deleted old file: {filename}")
                        except Exception as e:
                            error_msg = f"Failed to delete {filename}: {str(e)}"
                            logger.error(error_msg)
                            errors.append(error_msg)
            
            logger.info(f"✓ Cleanup complete: {deleted_count} files deleted")
            
            return {
                "status": "success",
                "deleted_count": deleted_count,
                "errors": errors,
                "timestamp": datetime.now().isoformat()
            }
            
        except Exception as e:
            error_msg = f"Cleanup failed: {str(e)}"
            logger.error(error_msg)
            return {
                "status": "error",
                "error": str(e),
                "timestamp": datetime.now().isoformat()
            }


def main():
    """Main execution function"""
    parser = argparse.ArgumentParser(
        description='Synchronize market data from OpenBB Platform'
    )
    parser.add_argument(
        '--symbols',
        type=str,
        default='AAPL,MSFT,GOOGL,AMZN,TSLA',
        help='Comma-separated list of symbols (default: AAPL,MSFT,GOOGL,AMZN,TSLA)'
    )
    parser.add_argument(
        '--days',
        type=int,
        default=30,
        help='Number of days of historical data to fetch (default: 30)'
    )
    parser.add_argument(
        '--cleanup',
        type=int,
        default=0,
        help='Clean up data files older than N days (0 = no cleanup)'
    )
    parser.add_argument(
        '--market-overview',
        action='store_true',
        help='Also sync market overview data'
    )
    
    args = parser.parse_args()
    
    # Parse symbols
    symbols = [s.strip().upper() for s in args.symbols.split(',')]
    
    logger.info("=" * 80)
    logger.info("Market Data Synchronization Started")
    logger.info("=" * 80)
    logger.info(f"Symbols: {', '.join(symbols)}")
    logger.info(f"Days: {args.days}")
    
    # Initialize OpenBB service
    openbb_url = os.getenv('OPENBB_BASE_URL', 'http://localhost:8000')
    openbb_key = os.getenv('OPENBB_API_KEY')
    
    service = OpenBBService(base_url=openbb_url, api_key=openbb_key)
    
    # Check service health
    if not service.health_check():
        logger.error("✗ OpenBB service is not available. Please start the service first.")
        sys.exit(1)
    
    logger.info("✓ OpenBB service is healthy")
    
    # Initialize synchronizer
    synchronizer = MarketDataSynchronizer(service)
    
    # Sync stock data
    stock_results = synchronizer.sync_stock_data(symbols, args.days)
    
    # Sync market overview if requested
    if args.market_overview:
        market_results = synchronizer.sync_market_overview()
    
    # Cleanup old data if requested
    if args.cleanup > 0:
        cleanup_results = synchronizer.cleanup_old_data(args.cleanup)
    
    # Print summary
    logger.info("=" * 80)
    logger.info("Synchronization Summary")
    logger.info("=" * 80)
    logger.info(f"Success: {stock_results['success_count']} symbols")
    logger.info(f"Errors: {stock_results['error_count']} symbols")
    
    if stock_results['error_count'] > 0:
        logger.warning("Errors encountered:")
        for error in stock_results['errors']:
            logger.warning(f"  - {error}")
    
    # Save results to file
    results_file = os.path.join(
        'logs',
        f"sync_results_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
    )
    os.makedirs('logs', exist_ok=True)
    
    with open(results_file, 'w') as f:
        json.dump(stock_results, f, indent=2)
    
    logger.info(f"Results saved to: {results_file}")
    logger.info("=" * 80)
    
    # Exit with appropriate code
    sys.exit(0 if stock_results['error_count'] == 0 else 1)


if __name__ == "__main__":
    main()
