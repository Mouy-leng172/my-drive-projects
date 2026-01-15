# Docker Deployment Guide - Trading Bridge FastAPI

Complete guide for deploying the Trading Bridge FastAPI service using Docker Desktop.

## Overview

This Docker setup provides:
- **FastAPI REST API** - HTTP interface for trading signals
- **MQL5 Bridge** - ZeroMQ connection to Expert Advisers
- **API Key Authentication** - Secure access control
- **Health Checks** - Container monitoring
- **Persistent Storage** - Configuration and logs

## Architecture

```
┌─────────────────────────────────────────┐
│         Docker Container                │
│                                         │
│  ┌─────────────────────────────────┐  │
│  │      FastAPI (Port 8000)        │  │
│  │  - REST API                     │  │
│  │  - API Key Auth                 │  │
│  │  - Health Check                 │  │
│  └──────────────┬──────────────────┘  │
│                 │                       │
│  ┌──────────────▼──────────────────┐  │
│  │   MQL5 Bridge (Port 5500)       │  │
│  │  - ZeroMQ Server                │  │
│  │  - Signal Queue                 │  │
│  └──────────────┬──────────────────┘  │
│                 │                       │
└─────────────────┼───────────────────────┘
                  │
                  ▼
         ┌────────────────┐
         │  MT5 Terminal  │
         │  Expert Adviser│
         └────────────────┘
```

## Prerequisites

1. **Docker Desktop** - Download and install from [docker.com](https://www.docker.com/products/docker-desktop/)
2. **Git** - For cloning the repository
3. **Text Editor** - For configuration files

## Quick Start

### 1. Clone Repository

```bash
git clone https://github.com/A6-9V/my-drive-projects.git
cd my-drive-projects
```

### 2. Configure Environment

Copy the example environment file:

```bash
cp .env.example .env
```

Edit `.env` and set your API key:

```env
TRADING_BRIDGE_API_KEY=your-secure-api-key-here
```

**Generate a secure API key:**

```bash
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

### 3. Configure Brokers (Optional)

Copy broker configuration:

```bash
cp trading-bridge/config/brokers.json.example trading-bridge/config/brokers.json
```

Edit `trading-bridge/config/brokers.json` with your broker details.

### 4. Start Container

Using Docker Compose (recommended):

```bash
docker-compose up -d
```

Or build and run manually:

```bash
docker build -f Dockerfile.fastapi -t trading-bridge-api .
docker run -d -p 8000:8000 -p 5500:5500 --name trading-bridge-api trading-bridge-api
```

### 5. Verify Deployment

Check container status:

```bash
docker-compose ps
```

Check health:

```bash
curl http://localhost:8000/health
```

View logs:

```bash
docker-compose logs -f trading-bridge-api
```

## API Documentation

Once running, access the interactive API documentation:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## API Endpoints

### Public Endpoints

#### GET /
Basic API information

```bash
curl http://localhost:8000/
```

#### GET /health
Health check (no authentication required)

```bash
curl http://localhost:8000/health
```

Response:
```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:00Z",
  "bridge_connected": true
}
```

### Authenticated Endpoints

All other endpoints require API key authentication via `X-API-Key` header.

#### GET /bridge/status
Get MQL5 bridge status

```bash
curl -H "X-API-Key: your-api-key" http://localhost:8000/bridge/status
```

Response:
```json
{
  "connection_status": "connected",
  "queue_size": 0,
  "stats": {
    "signals_sent": 10,
    "signals_received": 5,
    "errors": 0,
    "reconnections": 0
  },
  "last_heartbeat": "2024-01-15T10:29:55Z"
}
```

#### POST /signals
Submit a trade signal

```bash
curl -X POST http://localhost:8000/signals \
  -H "X-API-Key: your-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "symbol": "EURUSD",
    "broker": "EXNESS",
    "action": "BUY",
    "lot_size": 0.01,
    "stop_loss": 1.0850,
    "take_profit": 1.0950,
    "comment": "Test signal"
  }'
```

Response:
```json
{
  "success": true,
  "message": "Signal queued successfully",
  "signal_id": "abc123xyz"
}
```

#### GET /signals/queue
Get signal queue status

```bash
curl -H "X-API-Key: your-api-key" http://localhost:8000/signals/queue
```

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `API_HOST` | FastAPI bind address | `0.0.0.0` |
| `API_PORT` | FastAPI port | `8000` |
| `BRIDGE_HOST` | Bridge bind address | `0.0.0.0` |
| `BRIDGE_PORT` | Bridge port | `5500` |
| `TRADING_BRIDGE_API_KEY` | API authentication key | `dev-key-change-me` |

### Volume Mounts

| Container Path | Host Path | Purpose |
|----------------|-----------|---------|
| `/app/trading-bridge/config` | `./trading-bridge/config` | Configuration files |
| `/app/trading-bridge/logs` | `./trading-bridge/logs` | Log files |
| `/app/trading-bridge/data` | `./trading-bridge/data` | Trading data |

## Connecting Expert Adviser

### 1. Configure MT5 Expert Adviser

Set these parameters in your EA:
- **BridgeHost**: IP address of Docker host
  - Windows/Mac: Use `host.docker.internal`
  - Linux: Use host IP (e.g., `192.168.1.100`)
- **BridgePort**: `5500`
- **BrokerName**: `EXNESS` (or your broker)

### 2. Windows Docker Desktop

If running MT5 on the same Windows machine as Docker:

```mql5
string BridgeHost = "host.docker.internal";
int BridgePort = 5500;
```

### 3. Remote Connection

If MT5 is on a different machine:

1. Expose bridge port on host machine
2. Configure firewall to allow connections
3. Use host IP in EA:

```mql5
string BridgeHost = "192.168.1.100";  // Docker host IP
int BridgePort = 5500;
```

## Docker Commands

### Start Service

```bash
docker-compose up -d
```

### Stop Service

```bash
docker-compose down
```

### View Logs

```bash
docker-compose logs -f
```

### Restart Service

```bash
docker-compose restart
```

### Rebuild After Changes

```bash
docker-compose up -d --build
```

### Execute Commands in Container

```bash
docker-compose exec trading-bridge-api bash
```

## Monitoring

### Container Health

```bash
docker-compose ps
```

### Resource Usage

```bash
docker stats trading-bridge-api
```

### Application Logs

```bash
# Real-time logs
docker-compose logs -f trading-bridge-api

# Last 100 lines
docker-compose logs --tail=100 trading-bridge-api

# Logs from host filesystem
tail -f trading-bridge/logs/fastapi_*.log
tail -f trading-bridge/logs/mql5_bridge_*.log
```

## Troubleshooting

### Container Won't Start

1. Check Docker is running
2. Check port availability:
   ```bash
   netstat -an | grep 8000
   netstat -an | grep 5500
   ```
3. View container logs:
   ```bash
   docker-compose logs trading-bridge-api
   ```

### Bridge Not Connecting

1. Verify bridge is listening:
   ```bash
   curl http://localhost:8000/bridge/status -H "X-API-Key: your-api-key"
   ```

2. Check EA can reach Docker host:
   - Windows/Mac: Use `host.docker.internal`
   - Test connection from MT5 machine

3. Verify firewall rules allow port 5500

### API Authentication Failing

1. Verify API key in `.env` file
2. Check container has correct environment:
   ```bash
   docker-compose exec trading-bridge-api env | grep API_KEY
   ```
3. Ensure header is correct: `X-API-Key: your-key`

### High CPU/Memory Usage

1. Check signal queue size (may be backed up)
2. Review logs for errors
3. Restart container:
   ```bash
   docker-compose restart
   ```

## Security Best Practices

1. **Change Default API Key**
   - Never use `dev-key-change-me` in production
   - Generate strong random keys

2. **Restrict Network Access**
   - Use firewall rules
   - Only expose ports as needed
   - Consider using Docker networks

3. **Keep Secrets Secure**
   - Never commit `.env` file
   - Never commit `brokers.json`
   - Use environment variables

4. **Update Regularly**
   - Keep Docker images updated
   - Update Python dependencies
   - Monitor security advisories

## Production Deployment

For production use:

1. **Use HTTPS**
   - Add reverse proxy (nginx/traefik)
   - Configure SSL certificates

2. **Enable Monitoring**
   - Add Prometheus metrics
   - Configure alerting

3. **Use Docker Secrets**
   - For sensitive values
   - Instead of environment variables

4. **Set Resource Limits**
   ```yaml
   services:
     trading-bridge-api:
       deploy:
         resources:
           limits:
             cpus: '1'
             memory: 512M
   ```

## Backup and Recovery

### Backup Configuration

```bash
# Backup config directory
tar -czf trading-bridge-config-backup.tar.gz trading-bridge/config/

# Backup logs
tar -czf trading-bridge-logs-backup.tar.gz trading-bridge/logs/
```

### Restore Configuration

```bash
# Extract backup
tar -xzf trading-bridge-config-backup.tar.gz
```

### Database Backup

If using data persistence:

```bash
docker-compose exec trading-bridge-api \
  tar -czf - /app/trading-bridge/data > data-backup.tar.gz
```

## Updates and Maintenance

### Update Application

```bash
# Pull latest code
git pull

# Rebuild and restart
docker-compose up -d --build
```

### Update Dependencies

Edit `trading-bridge/requirements.txt`, then:

```bash
docker-compose build --no-cache
docker-compose up -d
```

## Support

For issues or questions:
1. Check logs: `docker-compose logs`
2. Verify configuration files
3. Review API documentation at `/docs`
4. Check GitHub issues

## License

See repository LICENSE file.
