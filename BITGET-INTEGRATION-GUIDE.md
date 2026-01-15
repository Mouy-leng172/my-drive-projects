# Bitget Integration Guide

This guide covers integrating Bitget cryptocurrency exchange with the trading automation system.

## Overview

Bitget is a cryptocurrency derivatives and spot trading platform. This integration supports:
- **Spot Trading** - Trade cryptocurrencies directly
- **USDT Futures** - Perpetual and futures contracts
- **Multiple Networks** - Automatic network selection for optimal performance
- **Full API Access** - Place orders, manage positions, check account status

## Getting Started

### 1. Create Bitget Account

If you don't have a Bitget account:
1. Visit [https://www.bitget.com](https://www.bitget.com)
2. Sign up for an account
3. Complete KYC verification (required for API access)
4. Enable 2FA for security

### 2. Generate API Keys

1. Log in to Bitget
2. Go to **API Management** (Profile → API)
3. Click **Create API**
4. Set API permissions:
   - ✅ Read - View account information
   - ✅ Trade - Place and manage orders
   - ❌ Withdraw - (Not recommended for trading bots)
5. Set IP whitelist (optional but recommended)
6. Save your:
   - **API Key**
   - **Secret Key**
   - **Passphrase**

**⚠️ IMPORTANT**: Save these credentials securely. You won't be able to view the Secret Key again!

### 3. Configure Environment Variables

Add Bitget credentials to your `.env` file:

```bash
# Bitget API Credentials
BITGET_API_KEY=your_api_key_here
BITGET_API_SECRET=your_secret_key_here
BITGET_PASSPHRASE=your_passphrase_here

# Network selection
BITGET_NETWORK=Automatic
```

### 4. Update Broker Configuration

Edit `trading-bridge/config/brokers.json`:

```json
{
  "brokers": [
    {
      "name": "BITGET",
      "api_url": "https://api.bitget.com",
      "account_id": "YOUR_UID",
      "api_key": "YOUR_API_KEY",
      "api_secret": "YOUR_SECRET_KEY",
      "passphrase": "YOUR_PASSPHRASE",
      "network": "Automatic",
      "product_type": "USDT-FUTURES",
      "enabled": true,
      "rate_limit": {
        "requests_per_minute": 120,
        "requests_per_second": 20
      }
    }
  ]
}
```

### 5. Test Network Connectivity

Run the network test script:

```powershell
# On Windows
.\test-bitget-network.ps1

# On Linux/Mac with PowerShell
pwsh test-bitget-network.ps1
```

This will test all available networks and recommend the best one based on latency.

## Network Selection

Bitget provides multiple network endpoints for redundancy and performance:

| Network | Endpoint | Average Latency | Status |
|---------|----------|----------------|--------|
| Network-1 | 118.67.205.90 | 118ms | ✅ Active |
| Network-2 | 118.67.205.90 | 249ms | ✅ Active |
| Network-3 | 118.67.205.90 | 368ms | ✅ Active |
| Network-4 | 118.67.205.90 | 471ms | ✅ Active |
| Automatic | api.bitget.com | Auto-select | ✅ Recommended |

**Recommendation**: Use `"Automatic"` to let the system choose the optimal network.

### Manual Network Selection

To manually select a network, update your configuration:

```json
{
  "network": "Network-1"
}
```

## Product Types

Bitget supports two product types:

### 1. USDT Futures (Default)
```json
{
  "product_type": "USDT-FUTURES"
}
```
- Perpetual and delivery contracts
- Leverage up to 125x
- USDT-margined positions

### 2. Spot Trading
```json
{
  "product_type": "SPOT"
}
```
- Direct cryptocurrency trading
- No leverage
- Immediate settlement

## Using Bitget API

### Example: Place Order

```python
from trading_bridge.python.brokers import BitgetAPI, BitgetConfig

# Create configuration
config = BitgetConfig(
    name="BITGET",
    api_url="https://api.bitget.com",
    account_id="your_uid",
    api_key="your_api_key",
    api_secret="your_secret",
    passphrase="your_passphrase",
    network="Automatic",
    product_type="USDT-FUTURES"
)

# Initialize API
bitget = BitgetAPI(config)

# Place market order
result = bitget.place_order(
    symbol="BTCUSDT",
    action="BUY",
    lot_size=0.1,
    stop_loss=45000,
    take_profit=55000
)

if result.success:
    print(f"Order placed: {result.order_id}")
else:
    print(f"Error: {result.message}")
```

### Example: Get Account Info

```python
# Get account information
account = bitget.get_account_info()

print(f"Balance: {account.balance} USDT")
print(f"Equity: {account.equity} USDT")
print(f"Free Margin: {account.free_margin} USDT")
```

### Example: Get Positions

```python
# Get all open positions
positions = bitget.get_positions()

for pos in positions:
    print(f"Symbol: {pos.symbol}")
    print(f"Type: {pos.type}")
    print(f"Size: {pos.volume}")
    print(f"Profit: {pos.profit} USDT")
```

## Trading Symbols

Common Bitget trading symbols:

### USDT Futures
- `BTCUSDT` - Bitcoin
- `ETHUSDT` - Ethereum
- `BNBUSDT` - Binance Coin
- `ADAUSDT` - Cardano
- `SOLUSDT` - Solana
- `XRPUSDT` - Ripple

### Spot
- `BTCUSDT_SPBL` - Bitcoin Spot
- `ETHUSDT_SPBL` - Ethereum Spot

## Risk Management

### Position Sizing
```python
# Calculate lot size based on risk
lot_size = bitget.calculate_lot_size(
    risk_percent=1.0,      # Risk 1% of account
    stop_loss_pips=100,    # 100 pip stop loss
    account_balance=10000  # Account balance
)
```

### Stop Loss and Take Profit
Always set stop loss and take profit when placing orders:
```python
result = bitget.place_order(
    symbol="BTCUSDT",
    action="BUY",
    lot_size=0.1,
    stop_loss=48000,    # Stop at $48,000
    take_profit=52000   # Profit at $52,000
)
```

## Rate Limits

Bitget API has rate limits to prevent abuse:
- **Requests per minute**: 120
- **Requests per second**: 20

The system automatically handles rate limiting, but be aware when making bulk operations.

## Notifications

Telegram notifications are automatically sent for:
- Order placements
- Position changes
- Account alerts
- API errors

Configure notifications in the trading bridge service.

## Troubleshooting

### API Connection Failed

**Problem**: Cannot connect to Bitget API

**Solutions**:
1. Run network test: `.\test-bitget-network.ps1`
2. Check firewall settings
3. Verify API credentials
4. Try different network selection

### Invalid Signature

**Problem**: API returns "Invalid signature" error

**Solutions**:
1. Verify API Key, Secret, and Passphrase
2. Check system time is synchronized (NTP)
3. Ensure no extra spaces in credentials

### Order Rejected

**Problem**: Orders are rejected

**Solutions**:
1. Check account balance
2. Verify symbol format (e.g., `BTCUSDT` not `BTC/USDT`)
3. Ensure minimum order size requirements
4. Check leverage and margin settings

### Rate Limit Exceeded

**Problem**: API returns "Rate limit exceeded"

**Solutions**:
1. Reduce request frequency
2. Implement request queuing
3. Use websocket for real-time data (future enhancement)

## Security Best Practices

1. **Never share API credentials**
2. **Use IP whitelist** - Restrict API access to your server IP
3. **Limit permissions** - Only enable Read and Trade, not Withdraw
4. **Rotate keys regularly** - Generate new API keys periodically
5. **Monitor activity** - Check API logs for suspicious activity
6. **Use 2FA** - Enable two-factor authentication on your account

## API Documentation

Official Bitget API documentation:
- **Main Docs**: [https://www.bitget.com/api-doc](https://www.bitget.com/api-doc)
- **Futures API**: [https://www.bitget.com/api-doc/contract/trade](https://www.bitget.com/api-doc/contract/trade)
- **Spot API**: [https://www.bitget.com/api-doc/spot/trade](https://www.bitget.com/api-doc/spot/trade)

## Support

For issues:
1. Check API status: [https://status.bitget.com](https://status.bitget.com)
2. Review error codes in API documentation
3. Test with network test script
4. Contact Bitget support if API issues persist

## Additional Information

### Device Information from Problem Statement
```
Basic information
ID: et72KqljQVSoVXCHph6Qt8:APA91bEJ8XMboOlw8Q_8UDnX...
Version: 2_2.73.1_TECNO LI9_15_G1706_10.0.31-5
About Bitget v2.73.1
UID: 7170837871
```

This information is from the Bitget mobile app and can be used to verify your account when configuring the API.

## Future Enhancements

Planned improvements:
- [ ] WebSocket support for real-time data
- [ ] Advanced order types (limit, stop-limit, etc.)
- [ ] Portfolio management features
- [ ] Automated trading strategies
- [ ] Performance analytics dashboard
