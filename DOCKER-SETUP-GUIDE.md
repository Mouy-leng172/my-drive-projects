# Docker Container Setup Guide

This guide covers running the My Drive Projects automation system in Docker containers.

## Prerequisites

- Docker installed (Docker Desktop on Windows, or Docker Engine on Linux)
- Docker Compose installed (usually comes with Docker Desktop)
- Environment variables configured

## Quick Start

### 1. Create Environment Configuration

Copy the example environment file and fill in your credentials:

```bash
cp .env.example .env
```

Edit `.env` and add your actual credentials:
- Telegram Bot Token and Chat ID
- Bitget API credentials (API Key, Secret, Passphrase)
- Exness API credentials (if using)

### 2. Build and Start Containers

```bash
# Build the Docker image
docker-compose build

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f
```

### 3. Verify Services

```bash
# Check running containers
docker-compose ps

# Check trading bridge logs
docker-compose logs trading-bridge

# Check notifications service
docker-compose logs notifications
```

## Available Services

### 1. Trading Bridge Service
- **Container**: `my-drive-trading-bridge`
- **Port**: 5500 (ZeroMQ communication)
- **Purpose**: Main trading automation service with Python-MQL5 bridge
- **Includes**:
  - Multi-broker API support (Exness, Bitget)
  - Telegram notifications
  - Background service for 24/7 operation

### 2. Notifications Service
- **Container**: `my-drive-notifications`
- **Purpose**: Standalone notification service for Telegram alerts
- **Use**: Send trading alerts, system status, and error notifications

### 3. Project Scanner Service
- **Container**: `my-drive-project-scanner`
- **Purpose**: Scan and manage multiple projects across drives

## Configuration

### Environment Variables

All configuration is done through environment variables in the `.env` file:

```bash
# Telegram
TELEGRAM_BOT_TOKEN=your_bot_token
TELEGRAM_CHAT_ID=your_chat_id

# Bitget
BITGET_API_KEY=your_api_key
BITGET_API_SECRET=your_api_secret
BITGET_PASSPHRASE=your_passphrase
BITGET_NETWORK=Automatic  # or Network-1, Network-2, etc.

# Exness
EXNESS_API_KEY=your_api_key
EXNESS_API_SECRET=your_api_secret
```

### Broker Configuration

Create `trading-bridge/config/brokers.json` from the example:

```bash
cp trading-bridge/config/brokers.json.example trading-bridge/config/brokers.json
```

Edit the file to configure your brokers.

## Docker Commands

### Basic Operations

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# Restart a specific service
docker-compose restart trading-bridge

# View logs
docker-compose logs -f [service-name]

# Execute command in container
docker-compose exec trading-bridge bash
```

### Maintenance

```bash
# Rebuild after code changes
docker-compose build --no-cache

# Clean up old images
docker system prune -a

# View resource usage
docker stats
```

## Volumes and Data Persistence

The following directories are mounted as volumes:
- `./trading-bridge/config` - Broker and symbol configuration
- `./trading-bridge/logs` - Service logs
- `./trading-bridge/data` - Trading data and history

These directories persist across container restarts.

## Networking

All services are connected via the `trading-network` bridge network:
- Services can communicate with each other by container name
- External access is available on exposed ports (e.g., 5500)

## Troubleshooting

### Container Won't Start

1. Check logs: `docker-compose logs [service-name]`
2. Verify environment variables in `.env`
3. Ensure no port conflicts (especially port 5500)

### Connection Issues

1. Test network: `pwsh test-bitget-network.ps1`
2. Verify firewall settings
3. Check API credentials

### Python Module Errors

If you see import errors:
```bash
# Rebuild with updated dependencies
docker-compose build --no-cache
```

### View Container Resources

```bash
# Check CPU and memory usage
docker stats

# Inspect a specific container
docker inspect my-drive-trading-bridge
```

## Health Checks

The trading-bridge service includes health checks that run every 30 seconds:
- Checks if log directory exists
- Verifies service is responsive

View health status:
```bash
docker-compose ps
```

## Security Best Practices

1. **Never commit `.env` file** - It contains sensitive credentials
2. **Use strong API keys** - Generate dedicated keys for Docker deployment
3. **Limit API permissions** - Only grant necessary permissions to API keys
4. **Monitor logs** - Regularly check for suspicious activity
5. **Keep images updated** - Regularly rebuild with latest base images

## Production Deployment

For production use:

1. Use Docker secrets instead of environment variables
2. Set up log rotation
3. Configure automatic restarts: `restart: always`
4. Monitor resource usage
5. Set up alerts for container failures

## Updates and Maintenance

### Updating the System

```bash
# Pull latest code
git pull

# Rebuild and restart
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Backup Important Data

```bash
# Backup configuration
tar -czf backup-config.tar.gz trading-bridge/config/

# Backup logs
tar -czf backup-logs.tar.gz trading-bridge/logs/

# Backup data
tar -czf backup-data.tar.gz trading-bridge/data/
```

## Support

For issues:
1. Check container logs
2. Verify configuration files
3. Test network connectivity
4. Review security settings

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Bitget API Documentation](https://www.bitget.com/api-doc/)
- [Trading Bridge README](trading-bridge/README.md)
