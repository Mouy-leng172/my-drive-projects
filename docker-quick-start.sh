#!/bin/bash
# Quick Start Script for Trading Bridge Docker Container
# Run with: ./docker-quick-start.sh

set -e

echo "============================================"
echo "Trading Bridge Docker Quick Start"
echo "============================================"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed!"
    echo "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop/"
    exit 1
fi

echo "✅ Docker is installed"

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo "❌ Docker is not running!"
    echo "Please start Docker Desktop and try again."
    exit 1
fi

echo "✅ Docker is running"

# Check if .env exists, if not copy from .env.example
if [ ! -f .env ]; then
    echo ""
    echo "📝 Creating .env file from .env.example..."
    cp .env.example .env
    
    # Generate a random API key
    if command -v python3 &> /dev/null; then
        # Check if secrets module is available
        if python3 -c "import secrets" 2>/dev/null; then
            API_KEY=$(python3 -c "import secrets; print(secrets.token_urlsafe(32))")
            # Use | as delimiter (won't appear in base64url tokens which only use A-Za-z0-9_-)
            if [[ "$OSTYPE" == "darwin"* ]]; then
                # macOS
                sed -i '' "s|dev-key-change-me|$API_KEY|" .env
            else
                # Linux
                sed -i "s|dev-key-change-me|$API_KEY|" .env
            fi
            echo "✅ Generated secure API key"
        else
            # Fallback to openssl if available
            if command -v openssl &> /dev/null; then
                # Generate 32 bytes (256 bits) of random data as hex string
                API_KEY=$(openssl rand -hex 32)
                if [[ "$OSTYPE" == "darwin"* ]]; then
                    sed -i '' "s|dev-key-change-me|$API_KEY|" .env
                else
                    sed -i "s|dev-key-change-me|$API_KEY|" .env
                fi
                echo "✅ Generated secure API key using openssl"
            else
                echo "⚠️  Python secrets module not found. Please edit .env and set a secure API key!"
            fi
        fi
    else
        echo "⚠️  Python not found. Please edit .env and set a secure API key!"
    fi
fi

echo "✅ Environment file configured"

# Check if config files exist
if [ ! -f trading-bridge/config/brokers.json ]; then
    echo ""
    echo "📝 Creating default broker configuration..."
    cp trading-bridge/config/brokers.json.example trading-bridge/config/brokers.json
    echo "⚠️  Please edit trading-bridge/config/brokers.json with your broker credentials"
fi

if [ ! -f trading-bridge/config/symbols.json ]; then
    echo ""
    echo "📝 Creating default symbols configuration..."
    cp trading-bridge/config/symbols.json.example trading-bridge/config/symbols.json
fi

echo "✅ Configuration files ready"

# Build and start containers
echo ""
echo "🚀 Building and starting Docker containers..."
docker-compose up -d --build

# Wait for container to be healthy
echo ""
echo "⏳ Waiting for container to be ready..."
sleep 5

# Check health
MAX_RETRIES=12
RETRY_COUNT=0
while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -s http://localhost:8000/health > /dev/null 2>&1; then
        echo "✅ Container is healthy!"
        break
    fi
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo "   Waiting... ($RETRY_COUNT/$MAX_RETRIES)"
    sleep 5
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "⚠️  Container may not be fully ready yet. Check logs with: docker-compose logs"
fi

# Show status
echo ""
echo "============================================"
echo "🎉 Trading Bridge is running!"
echo "============================================"
echo ""
echo "📊 API Dashboard:  http://localhost:8000/docs"
echo "🏥 Health Check:   http://localhost:8000/health"
echo "📖 Documentation:  http://localhost:8000/redoc"
echo ""
echo "🔐 Your API Key is in: .env"
echo "   (TRADING_BRIDGE_API_KEY)"
echo ""
echo "📝 Useful Commands:"
echo "   View logs:      docker-compose logs -f"
echo "   Stop:           docker-compose down"
echo "   Restart:        docker-compose restart"
echo "   Status:         docker-compose ps"
echo ""
echo "📚 Full guide: DOCKER-DEPLOYMENT-GUIDE.md"
echo ""

# Test API
echo "🧪 Testing API..."
HEALTH_RESPONSE=$(curl -s http://localhost:8000/health)
echo "Response: $HEALTH_RESPONSE"
echo ""

# Extract and display API key
if [ -f .env ]; then
    echo "🔑 Your API Key:"
    grep "TRADING_BRIDGE_API_KEY=" .env | cut -d'=' -f2
    echo ""
fi

echo "✅ Setup complete! Visit http://localhost:8000/docs to explore the API"
