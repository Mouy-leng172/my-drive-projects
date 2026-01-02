#!/bin/bash
# Gemini CLI Installation Verification Script
# This script checks if Gemini CLI is properly installed and configured

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}=====================================================${NC}"
echo -e "${CYAN}  Gemini CLI Installation Verification${NC}"
echo -e "${CYAN}=====================================================${NC}"
echo ""

# Test 1: Check if Node.js is installed
echo -e "${YELLOW}[TEST 1] Checking Node.js installation...${NC}"
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    echo -e "${GREEN}[PASS] Node.js ${NODE_VERSION} is installed${NC}"
else
    echo -e "${RED}[FAIL] Node.js is not installed${NC}"
    exit 1
fi
echo ""

# Test 2: Check if npm is installed
echo -e "${YELLOW}[TEST 2] Checking npm installation...${NC}"
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm -v)
    echo -e "${GREEN}[PASS] npm ${NPM_VERSION} is installed${NC}"
else
    echo -e "${RED}[FAIL] npm is not installed${NC}"
    exit 1
fi
echo ""

# Test 3: Check Node.js version
echo -e "${YELLOW}[TEST 3] Verifying Node.js version (requires v18+)...${NC}"
NODE_MAJOR_VERSION=$(echo $NODE_VERSION | sed 's/v//' | cut -d. -f1)
if [ "$NODE_MAJOR_VERSION" -ge 18 ]; then
    echo -e "${GREEN}[PASS] Node.js version requirement met (v${NODE_MAJOR_VERSION})${NC}"
else
    echo -e "${RED}[FAIL] Node.js version is below v18 (current: v${NODE_MAJOR_VERSION})${NC}"
    exit 1
fi
echo ""

# Test 4: Check if Gemini CLI is installed
echo -e "${YELLOW}[TEST 4] Checking Gemini CLI installation...${NC}"
if command -v gemini &> /dev/null; then
    echo -e "${GREEN}[PASS] Gemini CLI is installed${NC}"
else
    echo -e "${RED}[FAIL] Gemini CLI is not installed${NC}"
    echo -e "${YELLOW}[INFO] Run './install-gemini-cli.sh' to install${NC}"
    exit 1
fi
echo ""

# Test 5: Check Gemini CLI version
echo -e "${YELLOW}[TEST 5] Verifying Gemini CLI version...${NC}"
GEMINI_VERSION=$(gemini --version 2>&1)
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[PASS] Gemini CLI version: ${GEMINI_VERSION}${NC}"
    
    # Check if it's the expected version
    if [ "$GEMINI_VERSION" = "0.22.5" ]; then
        echo -e "${GREEN}[INFO] Correct version installed (v0.22.5)${NC}"
    else
        echo -e "${YELLOW}[WARN] Different version installed (expected: v0.22.5, got: ${GEMINI_VERSION})${NC}"
    fi
else
    echo -e "${RED}[FAIL] Could not determine Gemini CLI version${NC}"
    exit 1
fi
echo ""

# Test 6: Check if Gemini CLI help works
echo -e "${YELLOW}[TEST 6] Testing Gemini CLI help command...${NC}"
if gemini --help &> /dev/null; then
    echo -e "${GREEN}[PASS] Gemini CLI help command works${NC}"
else
    echo -e "${RED}[FAIL] Gemini CLI help command failed${NC}"
    exit 1
fi
echo ""

# Test 7: Check PATH configuration
echo -e "${YELLOW}[TEST 7] Checking PATH configuration...${NC}"
GEMINI_PATH=$(which gemini)
if [ -n "$GEMINI_PATH" ]; then
    echo -e "${GREEN}[PASS] Gemini CLI found in PATH: ${GEMINI_PATH}${NC}"
else
    echo -e "${RED}[FAIL] Gemini CLI not found in PATH${NC}"
    exit 1
fi
echo ""

# Test 8: Check npm global packages
echo -e "${YELLOW}[TEST 8] Verifying npm global package installation...${NC}"
if npm list -g @google/gemini-cli &> /dev/null; then
    NPM_PACKAGE_VERSION=$(npm list -g @google/gemini-cli 2>&1 | grep @google/gemini-cli | head -1 | awk '{print $2}' | sed 's/@//')
    echo -e "${GREEN}[PASS] @google/gemini-cli installed globally (version: ${NPM_PACKAGE_VERSION})${NC}"
else
    echo -e "${YELLOW}[WARN] Could not verify npm global package (but gemini command works)${NC}"
fi
echo ""

# Test 9: Check API key configuration (optional)
echo -e "${YELLOW}[TEST 9] Checking API key configuration (optional)...${NC}"
if [ -n "$GEMINI_API_KEY" ]; then
    echo -e "${GREEN}[PASS] GEMINI_API_KEY environment variable is set${NC}"
    echo -e "${YELLOW}[INFO] API key length: ${#GEMINI_API_KEY} characters${NC}"
else
    echo -e "${YELLOW}[INFO] GEMINI_API_KEY not set (will use OAuth on first run)${NC}"
    echo -e "${YELLOW}[INFO] Set API key: export GEMINI_API_KEY=\"your_key\"${NC}"
fi
echo ""

# Test 10: Check documentation files
echo -e "${YELLOW}[TEST 10] Checking documentation files...${NC}"
DOCS_FOUND=0
if [ -f "GEMINI-CLI-SETUP-GUIDE.md" ]; then
    echo -e "${GREEN}[PASS] GEMINI-CLI-SETUP-GUIDE.md found${NC}"
    ((DOCS_FOUND++))
fi
if [ -f "GEMINI-CLI-QUICK-START.md" ]; then
    echo -e "${GREEN}[PASS] GEMINI-CLI-QUICK-START.md found${NC}"
    ((DOCS_FOUND++))
fi
if [ -f "gemini-cli-config.template" ]; then
    echo -e "${GREEN}[PASS] gemini-cli-config.template found${NC}"
    ((DOCS_FOUND++))
fi

if [ $DOCS_FOUND -ge 2 ]; then
    echo -e "${GREEN}[INFO] Documentation files present (${DOCS_FOUND}/3)${NC}"
elif [ $DOCS_FOUND -gt 0 ]; then
    echo -e "${YELLOW}[WARN] Some documentation files are missing (${DOCS_FOUND}/3)${NC}"
else
    echo -e "${YELLOW}[WARN] Documentation files not found${NC}"
fi
echo ""

# Summary
echo -e "${CYAN}=====================================================${NC}"
echo -e "${CYAN}  Verification Summary${NC}"
echo -e "${CYAN}=====================================================${NC}"
echo ""
echo -e "${GREEN}✓ All critical tests passed!${NC}"
echo ""
echo -e "${YELLOW}Installation Details:${NC}"
echo -e "  Node.js: ${NODE_VERSION}"
echo -e "  npm: ${NPM_VERSION}"
echo -e "  Gemini CLI: ${GEMINI_VERSION}"
echo -e "  Install Path: ${GEMINI_PATH}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo -e "  1. Run 'gemini --help' to see all available commands"
echo -e "  2. Run 'gemini' to start interactive mode"
echo -e "  3. Review documentation:"
echo -e "     - GEMINI-CLI-SETUP-GUIDE.md (comprehensive guide)"
echo -e "     - GEMINI-CLI-QUICK-START.md (quick reference)"
echo -e "  4. Try integration examples:"
echo -e "     - source ./gemini-cli-integration.sh"
echo ""
echo -e "${GREEN}✓ Gemini CLI is ready to use!${NC}"
echo ""
