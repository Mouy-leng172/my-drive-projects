FROM mcr.microsoft.com/powershell:7.5-ubuntu-24.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /repo
COPY . .

# Install Python dependencies for trading bridge
# Use virtual environment to avoid system package conflicts
RUN if [ -f /repo/trading-bridge/requirements.txt ]; then \
    python3 -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip3 install --no-cache-dir -r /repo/trading-bridge/requirements.txt || \
    echo "Warning: Python dependencies installation failed. Trading bridge may need manual setup."; \
    fi

# Add virtual environment to PATH
ENV PATH="/opt/venv/bin:$PATH"

# Reduce noise / telemetry in container environments
ENV POWERSHELL_TELEMETRY_OPTOUT=1

# Environment variables for configuration
ENV TELEGRAM_BOT_TOKEN=""
ENV TELEGRAM_CHAT_ID=""
ENV BITGET_API_KEY=""
ENV BITGET_API_SECRET=""
ENV BITGET_PASSPHRASE=""

# Copy entrypoint script
COPY docker-entrypoint.ps1 /usr/local/bin/docker-entrypoint.ps1
RUN chmod +x /usr/local/bin/docker-entrypoint.ps1

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD pwsh -Command "exit 0"

# Default: show a short help message
CMD ["pwsh","-NoLogo","-NoProfile","-File","/usr/local/bin/docker-entrypoint.ps1"]

