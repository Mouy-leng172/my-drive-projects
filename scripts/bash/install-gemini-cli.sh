#!/bin/bash
# Installation script for Google Gemini CLI v0.22.5
# This script installs the Gemini CLI on Linux/macOS systems

set -e

echo "====================================================="
echo "  Google Gemini CLI v0.22.5 Installation Script"
echo "====================================================="
echo ""

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored messages
print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Node.js is installed
print_info "Checking Node.js installation..."
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed. Please install Node.js 18+ first."
    print_info "Visit: https://nodejs.org/ or use a package manager:"
    print_info "  Ubuntu/Debian: curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs"
    print_info "  macOS: brew install node"
    exit 1
fi

NODE_VERSION=$(node -v)
print_success "Node.js ${NODE_VERSION} is installed"

# Check if npm is installed
print_info "Checking npm installation..."
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install npm first."
    exit 1
fi

NPM_VERSION=$(npm -v)
print_success "npm ${NPM_VERSION} is installed"

# Extract major version number from Node.js version (remove 'v' prefix)
NODE_MAJOR_VERSION=$(echo $NODE_VERSION | sed 's/v//' | cut -d. -f1)

# Check if Node.js version is 18 or higher
if [ "$NODE_MAJOR_VERSION" -lt 18 ]; then
    print_error "Node.js version 18+ is required. Current version: ${NODE_VERSION}"
    print_info "Please upgrade Node.js to version 18 or higher"
    exit 1
fi

print_success "Node.js version requirement met (v18+)"

# Install Gemini CLI
print_info "Installing Google Gemini CLI v0.22.5..."
echo ""

# Try to install globally
if npm install -g @google/gemini-cli@0.22.5 2>&1; then
    print_success "Gemini CLI v0.22.5 installed successfully!"
else
    print_error "Failed to install Gemini CLI globally."
    print_info "Trying installation without sudo (user-level)..."
    
    # Try without sudo (for systems where user has npm configured for global installs)
    if npm install -g @google/gemini-cli@0.22.5 --prefix ~/.local 2>&1; then
        print_success "Gemini CLI installed in user directory (~/.local)"
        print_info "Add ~/.local/bin to your PATH if not already present:"
        print_info "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    else
        print_error "Installation failed. Please check npm permissions."
        exit 1
    fi
fi

echo ""
print_info "Verifying installation..."

# Check if gemini command is available
if command -v gemini &> /dev/null; then
    GEMINI_VERSION=$(gemini --version 2>&1 || echo "unknown")
    print_success "Gemini CLI is installed: ${GEMINI_VERSION}"
else
    print_error "Gemini CLI command not found in PATH"
    print_info "You may need to add npm global bin directory to your PATH"
    print_info "Try: export PATH=\"\$(npm config get prefix)/bin:\$PATH\""
    exit 1
fi

echo ""
echo "====================================================="
echo "  Installation Complete!"
echo "====================================================="
echo ""
print_info "Next steps:"
echo "  1. Run 'gemini --help' to see available commands"
echo "  2. Run 'gemini' to start interactive mode"
echo "  3. On first run, you'll be prompted to:"
echo "     - Choose a theme"
echo "     - Login (Google Account or API key)"
echo ""
print_info "To set up API key (optional, for higher rate limits):"
echo "  export GEMINI_API_KEY=\"your_api_key_here\""
echo ""
print_info "For more information, visit:"
echo "  https://github.com/google-gemini/gemini-cli"
echo "  https://google-gemini.github.io/gemini-cli/"
echo ""
print_success "Happy coding with Gemini CLI! 🚀"
echo ""
