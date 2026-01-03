# Trading Bridge Configuration

This directory contains configuration files for the trading bridge system. All files with actual credentials are gitignored for security.

## Configuration Files

### Required Configuration

#### 1. brokers.json
**Purpose**: Broker API credentials and connection settings

**Setup**:
```bash
cp brokers.json.example brokers.json
# Edit brokers.json with your actual broker credentials
```

**Example Structure**:
```json
{
  "exness": {
    "api_key": "your_api_key",
    "api_secret": "your_api_secret",
    "account_number": "12345678",
    "server": "Exness-MT5Real",
    "enabled": true
  }
}
```

**Security**: This file is automatically gitignored. Never commit it!

#### 2. symbols.json
**Purpose**: Trading symbols configuration

**Setup**:
```bash
# For standard trading
cp symbols.json.example symbols.json

# For 18-symbol trading strategy
cp symbols-18-trading.json.example symbols.json
```

**Example Structure**:
```json
{
  "symbols": [
    {
      "symbol": "EURUSD",
      "enabled": true,
      "lot_size": 0.01,
      "max_trades": 3
    }
  ]
}
```

### Optional Configuration

#### 3. mql_io.json
**Purpose**: MQL.io service configuration for EA monitoring

**Setup**:
```bash
cp mql_io.json.example mql_io.json
# Edit mql_io.json to configure monitoring settings
```

**Features**:
- Expert Advisor monitoring
- Script execution tracking
- Operations logging
- Auto-recovery settings

#### 4. capital-allocation.json
**Purpose**: Multi-symbol capital allocation strategy

**Setup**:
```bash
cp capital-allocation.json.example capital-allocation.json
```

**Use Case**: Distribute capital across multiple symbols based on risk profiles

#### 5. communication-teams.json
**Purpose**: Team communication and notification configuration

**Setup**:
```bash
cp communication-teams.json.example communication-teams.json
```

**Features**:
- Telegram notifications
- Email alerts
- Webhook integrations

## Quick Setup

### Step 1: Copy Example Files

```powershell
# In PowerShell (Windows)
cd trading-bridge\config

# Required files
Copy-Item brokers.json.example brokers.json
Copy-Item symbols.json.example symbols.json

# Optional files
Copy-Item mql_io.json.example mql_io.json
Copy-Item capital-allocation.json.example capital-allocation.json
```

### Step 2: Edit Configuration Files

Open each copied file and update with your actual credentials:

1. **brokers.json** - Add your broker API credentials
2. **symbols.json** - Configure your trading symbols
3. **mql_io.json** - Configure EA monitoring (optional)

### Step 3: Verify Configuration

```powershell
# Run security check to ensure no credentials are exposed
cd ..\..
.\security-check-trading.ps1
```

## Configuration Details

### Broker Configuration (brokers.json)

#### Exness Broker
```json
{
  "exness": {
    "api_key": "YOUR_API_KEY",
    "api_secret": "YOUR_API_SECRET",
    "account_number": "YOUR_MT5_ACCOUNT",
    "server": "Exness-MT5Real",
    "enabled": true,
    "use_demo": false,
    "timeout": 30
  }
}
```

**Getting Exness API Credentials**:
1. Login to Exness Personal Area
2. Go to Settings → API
3. Generate new API Key and Secret
4. Copy credentials to brokers.json

#### Alternative Brokers
Add additional brokers with the same structure:
```json
{
  "broker_name": {
    "api_key": "...",
    "api_secret": "...",
    "account_number": "...",
    "server": "...",
    "enabled": true
  }
}
```

### Symbol Configuration (symbols.json)

#### Basic Configuration
```json
{
  "symbols": [
    {
      "symbol": "EURUSD",
      "enabled": true,
      "lot_size": 0.01,
      "max_trades": 3,
      "stop_loss": 50,
      "take_profit": 100,
      "trailing_stop": false
    }
  ],
  "global_settings": {
    "max_total_trades": 10,
    "max_drawdown_percent": 20,
    "risk_per_trade": 1.0
  }
}
```

#### 18-Symbol Trading Strategy
For the advanced 18-symbol strategy, use `symbols-18-trading.json.example`:
- Pre-configured with 18 major forex pairs
- Balanced risk distribution
- Optimized lot sizes
- Capital allocation strategy

### MQL.io Configuration (mql_io.json)

```json
{
  "monitoring": {
    "enabled": true,
    "interval_seconds": 60,
    "auto_recovery": false
  },
  "expert_advisors": [
    {
      "name": "PythonBridgeEA",
      "chart": "EURUSD",
      "timeframe": "H1",
      "monitor": true
    }
  ],
  "logging": {
    "level": "INFO",
    "max_log_size_mb": 100,
    "retain_days": 30
  }
}
```

## Environment Variables

You can also configure settings using environment variables (see `.env.example` in root):

```bash
# Broker credentials
EXNESS_API_KEY=your_api_key
EXNESS_API_SECRET=your_api_secret
EXNESS_ACCOUNT_NUMBER=your_account

# Trading settings
TRADING_BRIDGE_PORT=5500
TRADING_BRIDGE_HOST=localhost

# Logging
LOG_LEVEL=INFO
```

Environment variables take precedence over configuration files.

## Security Best Practices

### ✅ DO

- Keep configuration files local only
- Use `.env` for sensitive environment variables
- Store credentials in Windows Credential Manager when possible
- Regularly rotate API keys
- Use separate API keys for development and production
- Enable two-factor authentication on broker accounts

### ❌ DON'T

- Never commit configuration files with real credentials
- Don't share API keys via email or chat
- Don't use production credentials for testing
- Don't store credentials in code or scripts
- Don't reuse API keys across multiple systems

## Validation

### Check Configuration Files

```powershell
# Verify files exist
Test-Path config\brokers.json
Test-Path config\symbols.json

# Run security validation
.\security-check-trading.ps1
```

### Test API Connectivity

```powershell
# Test broker API connection (if available)
python -c "from python.brokers.exness_api import ExnessAPI; api = ExnessAPI(); print(api.test_connection())"
```

## Troubleshooting

### Issue: Configuration file not found

**Solution**:
```powershell
# Copy example files
cd trading-bridge\config
Copy-Item *.example *.json -Exclude *.example
# Remove .example extension manually from each file
```

### Issue: API authentication failed

**Solution**:
1. Verify API key and secret in brokers.json
2. Check if API is enabled in broker account
3. Verify account number matches MT5 account
4. Ensure server name is correct

### Issue: Invalid JSON format

**Solution**:
1. Use a JSON validator (e.g., jsonlint.com)
2. Check for missing commas or brackets
3. Verify string values are in quotes
4. Remove trailing commas

## Advanced Configuration

### Multi-Broker Setup

Configure multiple brokers for redundancy:

```json
{
  "exness": { ... },
  "ic_markets": { ... },
  "fxpro": { ... }
}
```

### Custom Symbol Groups

Organize symbols by strategy:

```json
{
  "symbol_groups": {
    "majors": ["EURUSD", "GBPUSD", "USDJPY"],
    "minors": ["EURGBP", "EURJPY"],
    "exotics": ["USDTRY", "USDZAR"]
  }
}
```

### Risk Management Profiles

Define different risk profiles:

```json
{
  "risk_profiles": {
    "conservative": {
      "risk_per_trade": 0.5,
      "max_trades": 5
    },
    "aggressive": {
      "risk_per_trade": 2.0,
      "max_trades": 20
    }
  }
}
```

## Support

For configuration issues:
1. Check `TRADING-SYSTEM-QUICK-START.md` in root
2. Review `trading-bridge/README.md`
3. Run `validate-setup.ps1` for system check
4. Check logs in `trading-bridge/logs/`

## Related Documentation

- **TRADING-SYSTEM-QUICK-START.md** - Trading system setup
- **SECURITY.md** - Security guidelines (coming soon)
- **HOW-TO-RUN.md** - General setup guide
- **PREREQUISITES.md** - System requirements

---

**Last Updated**: 2026-01-02  
**Maintained by**: A6-9V Organization  
**Security Level**: Sensitive - Never commit actual configuration files
