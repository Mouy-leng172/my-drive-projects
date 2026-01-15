# Scripts Directory

This directory contains automation scripts for the my-drive-projects repository.

## Available Scripts

### sync_market_data.py

Synchronizes market data from OpenBB Platform to local storage.

**Usage**:
```bash
# Sync default symbols (AAPL, MSFT, GOOGL, AMZN, TSLA) for 30 days
python sync_market_data.py

# Sync specific symbols
python sync_market_data.py --symbols AAPL,MSFT,NVDA --days 90

# Include market overview and cleanup old data
python sync_market_data.py --symbols SPY,QQQ --market-overview --cleanup 7
```

**Options**:
- `--symbols`: Comma-separated list of ticker symbols
- `--days`: Number of days of historical data (default: 30)
- `--cleanup`: Clean up files older than N days (default: 0 = no cleanup)
- `--market-overview`: Also sync market overview data

**Environment Variables**:
- `OPENBB_BASE_URL`: OpenBB service URL (default: http://localhost:8000)
- `OPENBB_API_KEY`: API key for authentication (optional)

**Output**:
- Data files: `data/market/{SYMBOL}_{DATE}.json`
- Log files: `logs/sync_market_data.log`
- Results: `logs/sync_results_{TIMESTAMP}.json`

## Adding New Scripts

When adding new scripts to this directory:

1. Use Python 3.11+ for compatibility
2. Add a docstring at the top explaining the script's purpose
3. Include command-line argument parsing with `argparse`
4. Log to both file and console
5. Save results in JSON format when applicable
6. Update this README with usage instructions

## Dependencies

Scripts in this directory depend on:
- Python 3.11+
- Packages from `../requirements.txt`
- OpenBB service running at configured URL

Install dependencies:
```bash
pip install -r ../requirements.txt
```
