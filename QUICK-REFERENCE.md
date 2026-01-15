# Quick Reference Guide

## 🚀 Getting Started - Choose Your Path

### Option 1: Docker Deployment (Recommended for Cross-Platform)

```bash
# 1. Setup environment
cp .env.example .env
nano .env  # Add your credentials

# 2. Start all services
docker-compose up -d

# 3. Check status
docker-compose ps
docker-compose logs -f trading-bridge
```

**Services Running**:
- Trading Bridge (Port 5500)
- Telegram Notifications
- Project Scanner

---

### Option 2: Windows Native Deployment

```powershell
# 1. Complete Windows Setup
.\complete-windows-setup.ps1

# 2. Start VPS Trading System
.\auto-start-vps-admin.ps1

# 3. Setup Trading System
.\setup-trading-system.ps1
```

---

## 📱 Telegram Notifications Setup

### Quick Setup:
```powershell
# Set environment variables
setx TRADINGBRIDGE_TELEGRAM_BOT_TOKEN "your_bot_token"
setx TRADINGBRIDGE_TELEGRAM_CHAT_ID "your_chat_id"

# Or for Docker, edit .env file
TELEGRAM_BOT_TOKEN=your_bot_token
TELEGRAM_CHAT_ID=your_chat_id
```

### Get Telegram Bot Token:
1. Message @BotFather on Telegram
2. Send `/newbot` and follow instructions
3. Copy the token provided
4. Get your chat ID from @userinfobot

---

## 💱 Bitget Integration

### Test Network Connection:
```powershell
.\test-bitget-network.ps1
```

### Configure Bitget:
1. Get API credentials from Bitget.com → API Management
2. Add to `.env` (Docker) or Windows Credential Manager
3. Update `trading-bridge/config/brokers.json`

```json
{
  "name": "BITGET",
  "api_key": "your_key",
  "api_secret": "your_secret",
  "passphrase": "your_passphrase",
  "network": "Automatic"
}
```

### Your Bitget Info:
- UID: 7170837871
- Network: Automatic (recommended)
- Product: USDT-FUTURES or SPOT

---

## 🔧 MQL5 Compilation

### Enhanced Compilation:
```powershell
.\compile-mql5-eas-enhanced.ps1
```

### Download from MQL5.io:
1. Open MetaTrader 5
2. Go to Market tab
3. Download your products
4. Run compilation script

---

## 📊 MT5 Terminal Info

From your logs:
- Login: 405347405
- Server: Exness-MT5Real8
- VPS: Jakarta 02: 0759730
- Status: 6 charts, 6 EAs active

---

## 🐳 Docker Commands Cheat Sheet

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f [service-name]

# Restart a service
docker-compose restart trading-bridge

# Rebuild after changes
docker-compose build --no-cache

# Execute command in container
docker-compose exec trading-bridge bash

# Check resource usage
docker stats
```

---

## 🔒 Security Checklist

- [ ] Never commit `.env` file
- [ ] Use strong API keys with limited permissions
- [ ] Enable 2FA on all trading accounts
- [ ] Whitelist IPs for API access
- [ ] Rotate credentials regularly
- [ ] Monitor API usage logs
- [ ] Use Windows Credential Manager for local storage

---

## 📚 Documentation Quick Links

- **Docker Setup**: [DOCKER-SETUP-GUIDE.md](DOCKER-SETUP-GUIDE.md)
- **Bitget Integration**: [BITGET-INTEGRATION-GUIDE.md](BITGET-INTEGRATION-GUIDE.md)
- **Code Organization**: [CODE-CONSOLIDATION-GUIDE.md](CODE-CONSOLIDATION-GUIDE.md)
- **Full Summary**: [IMPLEMENTATION-SUMMARY.md](IMPLEMENTATION-SUMMARY.md)
- **Main README**: [README.md](README.md)

---

## 🔍 Troubleshooting

### Docker won't start?
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Can't connect to Bitget?
```powershell
.\test-bitget-network.ps1
# Check firewall settings
# Verify API credentials
```

### MQL5 compilation fails?
- Ensure MetaTrader 5 is installed
- Run MT5 once before compiling
- Check MetaEditor is available

### Telegram not working?
- Verify bot token and chat ID
- Check environment variables
- Restart service after config changes

---

## 📞 Support Resources

### Official Documentation:
- [Docker Docs](https://docs.docker.com/)
- [Bitget API](https://www.bitget.com/api-doc/)
- [Telegram Bot API](https://core.telegram.org/bots/api)
- [MQL5 Reference](https://www.mql5.com/en/docs)

### Check Status:
- Bitget Status: https://status.bitget.com
- GitHub Status: https://www.githubstatus.com

---

## 🎯 Quick Commands Summary

| Task | Command |
|------|---------|
| Docker Start | `docker-compose up -d` |
| Docker Stop | `docker-compose down` |
| Test Bitget | `.\test-bitget-network.ps1` |
| Compile MQL5 | `.\compile-mql5-eas-enhanced.ps1` |
| VPS Start | `.\auto-start-vps-admin.ps1` |
| Security Check | `.\security-check-trading.ps1` |
| System Status | `.\system-status-report.ps1` |

---

## ✅ Verification Checklist

After setup, verify:
- [ ] Docker containers running: `docker-compose ps`
- [ ] Logs showing no errors: `docker-compose logs`
- [ ] Bitget connection works: `.\test-bitget-network.ps1`
- [ ] Telegram bot responds: Send test message
- [ ] MQL5 EAs compiled: Check `.ex5` files
- [ ] Port 5500 accessible: Trading bridge communication

---

## 🚨 Emergency Commands

### Stop Everything:
```bash
docker-compose down
# or on Windows
Stop-Process -Name "terminal64" -Force
```

### Backup Configuration:
```powershell
.\backup-to-usb.ps1
```

### Reset to Default:
```bash
git checkout main
git pull
docker-compose down -v
docker-compose up -d
```

---

## 💡 Tips

1. **Use Automatic Network**: Let Bitget select best network
2. **Start with Small Amounts**: Test with minimum funds first
3. **Monitor Logs**: Check regularly for errors
4. **Keep Credentials Safe**: Never share or commit
5. **Update Regularly**: Pull latest changes weekly

---

## 📈 Next Steps

1. ✅ Complete initial setup
2. ✅ Test with paper trading
3. ✅ Monitor for 24 hours
4. ✅ Gradually increase position sizes
5. ✅ Setup automated backups
6. ✅ Configure alerts
7. ✅ Document your strategy

---

**Last Updated**: December 24, 2025  
**Version**: 1.0.0  
**Status**: Production Ready ✅
