# Trading Bridge FastAPI - API Reference

Complete API reference for the Trading Bridge FastAPI service.

## Base URL

```
http://localhost:8000
```

## Authentication

Most endpoints require API key authentication via the `X-API-Key` header.

```bash
curl -H "X-API-Key: your-api-key-here" http://localhost:8000/endpoint
```

## Endpoints

### Public Endpoints

#### GET /

Get API information.

**Response:**
```json
{
  "name": "Trading Bridge API",
  "version": "1.0.0",
  "description": "REST API for MQL5 Trading Bridge",
  "docs": "/docs",
  "health": "/health"
}
```

#### GET /health

Health check endpoint (no authentication required).

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:00Z",
  "bridge_connected": true
}
```

#### GET /docs

Interactive API documentation (Swagger UI).

#### GET /redoc

Alternative API documentation (ReDoc).

---

### Authenticated Endpoints

All endpoints below require the `X-API-Key` header.

#### GET /bridge/status

Get MQL5 bridge connection status and statistics.

**Headers:**
- `X-API-Key`: Your API key

**Response:**
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

**Connection Status Values:**
- `listening` - Bridge is running, waiting for EA connection
- `connected` - EA is connected and communicating
- `disconnected` - EA connection lost
- `stopped` - Bridge is stopped

---

#### POST /signals

Submit a trade signal to be executed by the Expert Adviser.

**Headers:**
- `X-API-Key`: Your API key
- `Content-Type`: application/json

**Request Body:**
```json
{
  "symbol": "EURUSD",
  "broker": "EXNESS",
  "action": "BUY",
  "lot_size": 0.01,
  "stop_loss": 1.0850,
  "take_profit": 1.0950,
  "comment": "Trade comment"
}
```

**Parameters:**
- `symbol` (string, required) - Trading symbol (e.g., "EURUSD", "GBPUSD")
- `broker` (string, required) - Broker name (e.g., "EXNESS")
- `action` (string, required) - Trade action: "BUY", "SELL", or "CLOSE"
- `lot_size` (float, required) - Lot size (must be > 0)
- `stop_loss` (float, optional) - Stop loss price
- `take_profit` (float, optional) - Take profit price
- `comment` (string, optional) - Trade comment (default: "")

**Response:**
```json
{
  "success": true,
  "message": "Signal queued successfully",
  "signal_id": "EURUSD_BUY_1234567890"
}
```

**Error Response:**
```json
{
  "detail": "Invalid action. Must be one of: BUY, SELL, CLOSE"
}
```

---

#### GET /signals/queue

Get current signal queue status.

**Headers:**
- `X-API-Key`: Your API key

**Response:**
```json
{
  "queue_size": 3,
  "max_queue_size": 1000
}
```

---

## Error Responses

### 401 Unauthorized

Authentication failed - invalid or missing API key.

```json
{
  "detail": "Invalid or missing API key"
}
```

### 400 Bad Request

Invalid request parameters.

```json
{
  "detail": "Invalid action. Must be one of: BUY, SELL, CLOSE"
}
```

### 503 Service Unavailable

Bridge is not initialized or available.

```json
{
  "detail": "Bridge not initialized"
}
```

---

## Usage Examples

### Python

```python
import requests

API_URL = "http://localhost:8000"
API_KEY = "your-api-key-here"

headers = {
    "X-API-Key": API_KEY,
    "Content-Type": "application/json"
}

# Check health
response = requests.get(f"{API_URL}/health")
print(response.json())

# Get bridge status
response = requests.get(f"{API_URL}/bridge/status", headers=headers)
print(response.json())

# Submit trade signal
signal = {
    "symbol": "EURUSD",
    "broker": "EXNESS",
    "action": "BUY",
    "lot_size": 0.01,
    "stop_loss": 1.0850,
    "take_profit": 1.0950,
    "comment": "Automated trade"
}

response = requests.post(f"{API_URL}/signals", json=signal, headers=headers)
print(response.json())
```

### cURL

```bash
# Health check
curl http://localhost:8000/health

# Bridge status
curl -H "X-API-Key: your-api-key" \
  http://localhost:8000/bridge/status

# Submit signal
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
    "comment": "Test trade"
  }'
```

### JavaScript (Node.js)

```javascript
const axios = require('axios');

const API_URL = 'http://localhost:8000';
const API_KEY = 'your-api-key-here';

const headers = {
  'X-API-Key': API_KEY,
  'Content-Type': 'application/json'
};

// Check health
async function checkHealth() {
  const response = await axios.get(`${API_URL}/health`);
  console.log(response.data);
}

// Submit signal
async function submitSignal() {
  const signal = {
    symbol: 'EURUSD',
    broker: 'EXNESS',
    action: 'BUY',
    lot_size: 0.01,
    stop_loss: 1.0850,
    take_profit: 1.0950,
    comment: 'Automated trade'
  };
  
  const response = await axios.post(
    `${API_URL}/signals`,
    signal,
    { headers }
  );
  console.log(response.data);
}

checkHealth();
submitSignal();
```

### PowerShell

```powershell
$apiUrl = "http://localhost:8000"
$apiKey = "your-api-key-here"

$headers = @{
    "X-API-Key" = $apiKey
    "Content-Type" = "application/json"
}

# Health check
Invoke-RestMethod -Uri "$apiUrl/health" -Method Get

# Bridge status
Invoke-RestMethod -Uri "$apiUrl/bridge/status" -Headers $headers -Method Get

# Submit signal
$signal = @{
    symbol = "EURUSD"
    broker = "EXNESS"
    action = "BUY"
    lot_size = 0.01
    stop_loss = 1.0850
    take_profit = 1.0950
    comment = "Automated trade"
} | ConvertTo-Json

Invoke-RestMethod -Uri "$apiUrl/signals" -Headers $headers -Method Post -Body $signal
```

---

## Rate Limiting

Currently, there is no built-in rate limiting. Consider implementing rate limiting at the reverse proxy level (nginx, traefik) for production use.

## WebSocket Support

WebSocket support for real-time updates is not currently implemented but may be added in future versions.

## Best Practices

1. **Secure Your API Key**
   - Never commit API keys to version control
   - Use environment variables
   - Rotate keys regularly

2. **Error Handling**
   - Always check response status codes
   - Implement retry logic for transient failures
   - Log errors for debugging

3. **Signal Validation**
   - Validate parameters before submission
   - Check lot sizes against broker limits
   - Ensure stop loss/take profit levels are valid

4. **Monitoring**
   - Regularly check `/health` endpoint
   - Monitor bridge connection status
   - Watch queue size for backups

5. **Production Deployment**
   - Use HTTPS (reverse proxy with SSL)
   - Implement rate limiting
   - Set up monitoring and alerting
   - Use strong, randomly generated API keys

## Troubleshooting

### API Key Authentication Fails

- Verify API key is correct
- Ensure `X-API-Key` header is set
- Check environment variable is loaded correctly

### Bridge Not Connected

- Verify Docker container is running
- Check bridge port (5500) is accessible
- Ensure MT5 EA is configured with correct host/port
- Review bridge logs: `docker logs <container-name>`

### Signals Not Executing

- Check EA is running and attached to chart
- Verify EA has correct broker configuration
- Check MT5 allows automated trading
- Review EA logs in MT5

## Support

For issues or questions:
1. Check API documentation at `/docs`
2. Review Docker logs: `docker logs <container-name>`
3. Check `DOCKER-DEPLOYMENT-GUIDE.md`
4. Review trading-bridge logs in `logs/` directory
