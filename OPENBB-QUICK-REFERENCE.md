# OpenBB Integration - Quick Reference

## 🚀 Quick Start Commands

### Start OpenBB Service
```powershell
# Windows
.\start-openbb-service.ps1
# or
START-OPENBB-SERVICE.bat

# Linux/Mac
cd docker && docker-compose up -d openbb
```

### Test Connection
```bash
curl http://localhost:8000/health
# Expected: {"status":"ok","service":"OpenBB Platform API"}
```

### Sync Market Data
```bash
python scripts/sync_market_data.py --symbols AAPL,MSFT,GOOGL
```

### Stop Service
```bash
cd docker && docker-compose down
```

## 📁 Key Files

| File | Purpose |
|------|---------|
| `backend/services/openbb_service.py` | OpenBB API client |
| `configs/openbb.yaml` | Configuration settings |
| `docker/docker-compose.yml` | Service orchestration |
| `docker/openbb.Dockerfile` | OpenBB container definition |
| `scripts/sync_market_data.py` | Data synchronization tool |
| `OPENBB-INTEGRATION.md` | Full integration guide |
| `OPENBB-IMPLEMENTATION-SUMMARY.md` | Implementation details |
| `OPENBB-ARCHITECTURE-DIAGRAMS.md` | Visual architecture |

## 🔧 Configuration

### Environment Variables (.env file)
```bash
OPENBB_BASE_URL=http://localhost:8000
OPENBB_API_KEY=your-api-key-here
DB_HOST=localhost
DB_NAME=mydrivedb
```

### Key Configuration (configs/openbb.yaml)
```yaml
service:
  base_url: "http://localhost:8000"
  api_key: "${OPENBB_API_KEY}"
  
data:
  default_provider: "yfinance"
  providers: ["yfinance", "polygon", "alphavantage"]
  
market:
  watchlist: ["SPY", "QQQ", "AAPL", "MSFT"]
```

## 💻 Python Usage Examples

### Basic Usage
```python
from backend.services.openbb_service import OpenBBService

# Initialize
service = OpenBBService(base_url="http://localhost:8000")

# Check health
if service.health_check():
    # Get stock data
    data = service.get_stock_data("AAPL")
    
    # Get market data
    market = service.get_market_data(["SPY", "QQQ"])
    
    # Technical indicators
    rsi = service.get_technical_indicators("AAPL", "RSI", period=14)
```

### Advanced Usage
```python
# Economic indicators
gdp = service.get_economic_indicators("GDP", country="US")

# Company information
info = service.get_company_info("AAPL")

# Search symbols
results = service.search_symbols("apple", limit=10)
```

## 🐳 Docker Commands

```bash
# Start all services
docker-compose up -d

# Start only OpenBB
docker-compose up -d openbb

# View logs
docker logs openbb-service
docker-compose logs -f openbb

# Restart service
docker-compose restart openbb

# Stop all services
docker-compose down

# Rebuild containers
docker-compose build --no-cache
docker-compose up -d

# Check status
docker ps
docker stats openbb-service
```

## 🔍 Troubleshooting

### Service Won't Start
```bash
# Check Docker is running
docker ps

# Check logs
docker logs openbb-service

# Rebuild
cd docker
docker-compose down
docker-compose build --no-cache openbb
docker-compose up -d openbb
```

### Connection Refused
```bash
# Verify service is running
docker ps | grep openbb

# Check port mapping
docker port openbb-service

# Test with curl
curl -v http://localhost:8000/health
```

### Import Errors
```bash
# Install dependencies
pip install -r requirements.txt

# Check Python path
python -c "import sys; print(sys.path)"

# Verify OpenBB installation (if using submodule)
python -c "import openbb; print(openbb.__version__)"
```

## 📊 API Endpoints

When OpenBB service is running at `http://localhost:8000`:

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | GET | Health check |
| `/` | GET | API information |
| `/docs` | GET | Interactive API docs (Swagger) |
| `/api/stocks/historical` | GET | Historical stock data |
| `/api/market/data` | POST | Multiple symbols data |
| `/api/economy/{indicator}` | GET | Economic indicators |
| `/api/technical/{indicator}` | GET | Technical analysis |
| `/api/stocks/info/{symbol}` | GET | Company information |
| `/api/search` | GET | Symbol search |

## 🎯 Integration Points

### With Trading Bridge
```python
# In trading-bridge/python/strategies/
from backend.services.openbb_service import OpenBBService

service = OpenBBService()
market_data = service.get_stock_data("EURUSD")
# Use in strategy logic
```

### With VPS Services
```powershell
# In vps-services scripts
# Add OpenBB health check to master-controller.ps1
$openbbHealth = curl -s http://localhost:8000/health
```

### With Background Sync
```bash
# Schedule sync_market_data.py with cron (Linux) or Task Scheduler (Windows)
# Every hour: sync major indices
0 * * * * python /path/to/scripts/sync_market_data.py --symbols SPY,QQQ
```

## 📝 Decision Matrix

| Requirement | Option A (Service) | Option B (Submodule) |
|-------------|-------------------|----------------------|
| Production deployment | ✅ Recommended | ⚠️ Possible |
| Easy upgrades | ✅ Yes | ⚠️ Complex |
| Multiple apps | ✅ Yes | ❌ No |
| Offline development | ⚠️ Need Docker | ✅ Yes |
| Lowest latency | ⚠️ ~10ms overhead | ✅ Direct |
| Simple setup | ✅ Docker Compose | ⚠️ Git submodules |
| Fault isolation | ✅ Yes | ❌ No |

**Recommendation for this project**: **Option A (Service)** ✅

## 🔐 Security Checklist

- [ ] API keys stored in `.env` file (not committed)
- [ ] `.env` file in `.gitignore`
- [ ] HTTPS enabled for production
- [ ] Firewall rules configured
- [ ] Rate limiting enabled
- [ ] Regular security updates
- [ ] Logs don't contain sensitive data

## 📚 Resources

- **Documentation**: See `OPENBB-INTEGRATION.md`
- **Implementation**: See `OPENBB-IMPLEMENTATION-SUMMARY.md`
- **Architecture**: See `OPENBB-ARCHITECTURE-DIAGRAMS.md`
- **OpenBB Docs**: https://docs.openbb.co/
- **OpenBB GitHub**: https://github.com/OpenBB-finance/OpenBB

## 🆘 Getting Help

1. Check logs: `docker logs openbb-service`
2. Review documentation in this repo
3. Check OpenBB documentation: https://docs.openbb.co/
4. Verify Docker/Python setup
5. Check firewall/network settings

## ✅ Verification Checklist

- [ ] Docker Desktop installed and running
- [ ] Repository cloned and up to date
- [ ] `.env` file created from `.env.template`
- [ ] OpenBB service started successfully
- [ ] Health check returns OK
- [ ] Can fetch stock data via API
- [ ] Python dependencies installed
- [ ] Sync script runs successfully

---

**Quick Links**:
- Start Service: `.\start-openbb-service.ps1`
- Check Health: `curl http://localhost:8000/health`
- View Docs: `http://localhost:8000/docs`
- Sync Data: `python scripts/sync_market_data.py`

**Status**: Ready for Use
**Last Updated**: 2026-01-03
