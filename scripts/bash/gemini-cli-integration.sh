#!/bin/bash
# Gemini CLI Integration Examples for Linux/macOS
# This script demonstrates how to integrate Gemini CLI with existing bash automation

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Check if Gemini CLI is installed
if ! command -v gemini &> /dev/null; then
    echo -e "${RED}[ERROR] Gemini CLI is not installed.${NC}"
    echo -e "${YELLOW}[INFO] Run './install-gemini-cli.sh' to install.${NC}"
    exit 1
fi

echo -e "${CYAN}=====================================================${NC}"
echo -e "${CYAN}  Gemini CLI Integration Examples${NC}"
echo -e "${CYAN}=====================================================${NC}"
echo ""

# Example 1: Auto-generate commit messages
ai_commit() {
    echo -e "${YELLOW}[INFO] Generating AI commit message...${NC}"
    
    if ! git status --short &> /dev/null; then
        echo -e "${YELLOW}[INFO] Not in a git repository.${NC}"
        return 1
    fi
    
    local git_status=$(git status --short)
    if [ -z "$git_status" ]; then
        echo -e "${YELLOW}[INFO] No changes to commit.${NC}"
        return 0
    fi
    
    local diff=$(git diff --staged)
    if [ -z "$diff" ]; then
        echo -e "${YELLOW}[INFO] No staged changes. Staging all changes...${NC}"
        git add .
        diff=$(git diff --staged)
    fi
    
    if [ -n "$diff" ]; then
        echo -e "${YELLOW}[INFO] Asking Gemini CLI to generate commit message...${NC}"
        local commit_message=$(echo "$diff" | gemini "Generate a concise, professional git commit message that follows conventional commits format. Output only the commit message, no explanation.")
        
        echo ""
        echo -e "${GREEN}Suggested commit message:${NC}"
        echo -e "${WHITE}$commit_message${NC}"
        echo ""
        
        read -p "Use this message? (Y/n): " confirm
        if [ -z "$confirm" ] || [ "$confirm" = "Y" ] || [ "$confirm" = "y" ]; then
            git commit -m "$commit_message"
            echo -e "${GREEN}[OK] Committed successfully!${NC}"
        else
            echo -e "${YELLOW}[INFO] Commit cancelled.${NC}"
        fi
    fi
}

# Example 2: Code review for shell scripts
ai_review() {
    local file_path="$1"
    
    if [ -z "$file_path" ]; then
        echo -e "${RED}[ERROR] File path is required.${NC}"
        echo "Usage: ai_review <file_path>"
        return 1
    fi
    
    if [ ! -f "$file_path" ]; then
        echo -e "${RED}[ERROR] File not found: $file_path${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}[INFO] Reviewing $file_path with Gemini CLI...${NC}"
    echo ""
    
    gemini "Review this shell script for best practices, security issues, and potential improvements. Provide specific, actionable feedback." --file "$file_path"
}

# Example 3: Generate documentation for scripts
ai_document() {
    local file_path="$1"
    local output_path="$2"
    
    if [ -z "$file_path" ]; then
        echo -e "${RED}[ERROR] File path is required.${NC}"
        echo "Usage: ai_document <file_path> [output_path]"
        return 1
    fi
    
    if [ ! -f "$file_path" ]; then
        echo -e "${RED}[ERROR] File not found: $file_path${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}[INFO] Generating documentation for $file_path...${NC}"
    
    local docs=$(gemini "Generate comprehensive documentation for this script including: purpose, parameters, usage examples, and notes. Use markdown format." --file "$file_path")
    
    if [ -n "$output_path" ]; then
        echo "$docs" > "$output_path"
        echo -e "${GREEN}[OK] Documentation saved to: $output_path${NC}"
    else
        echo ""
        echo "$docs"
    fi
}

# Example 4: Explain git history
ai_explain_history() {
    local count="${1:-10}"
    
    echo -e "${YELLOW}[INFO] Analyzing recent git history...${NC}"
    
    local history=$(git log --oneline -"$count")
    local explanation=$(echo "$history" | gemini "Summarize these git commits in a concise paragraph, highlighting the main themes and changes.")
    
    echo ""
    echo "$explanation"
}

# Example 5: Security audit for a script
ai_security_audit() {
    local file_path="$1"
    
    if [ -z "$file_path" ]; then
        echo -e "${RED}[ERROR] File path is required.${NC}"
        echo "Usage: ai_security_audit <file_path>"
        return 1
    fi
    
    if [ ! -f "$file_path" ]; then
        echo -e "${RED}[ERROR] File not found: $file_path${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}[INFO] Running security audit on $file_path...${NC}"
    echo ""
    
    gemini "Perform a security audit of this script. Identify any potential vulnerabilities, hardcoded credentials, insecure practices, or security concerns. Provide specific recommendations." --file "$file_path"
}

# Example 6: Optimize code
ai_optimize() {
    local file_path="$1"
    
    if [ -z "$file_path" ]; then
        echo -e "${RED}[ERROR] File path is required.${NC}"
        echo "Usage: ai_optimize <file_path>"
        return 1
    fi
    
    if [ ! -f "$file_path" ]; then
        echo -e "${RED}[ERROR] File not found: $file_path${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}[INFO] Getting optimization suggestions for $file_path...${NC}"
    echo ""
    
    gemini "Analyze this code and suggest performance optimizations, better practices, and code improvements. Focus on shell script-specific optimizations." --file "$file_path"
}

# Example 7: Batch documentation for all scripts
ai_document_all_scripts() {
    local directory="${1:-.}"
    local output_directory="${2:-./docs}"
    
    echo -e "${YELLOW}[INFO] Generating documentation for all shell scripts in $directory...${NC}"
    
    if [ ! -d "$output_directory" ]; then
        mkdir -p "$output_directory"
        echo -e "${GREEN}[OK] Created output directory: $output_directory${NC}"
    fi
    
    local count=0
    for script in "$directory"/*.sh; do
        if [ -f "$script" ]; then
            echo -e "${YELLOW}[INFO] Documenting: $(basename "$script")...${NC}"
            
            local basename=$(basename "$script" .sh)
            local output_file="$output_directory/${basename}-docs.md"
            ai_document "$script" "$output_file"
            ((count++))
        fi
    done
    
    echo ""
    echo -e "${GREEN}[OK] Generated documentation for $count scripts in $output_directory${NC}"
}

# Example 8: Interactive AI assistant for debugging
ai_debug_help() {
    local error_message="$1"
    
    if [ -z "$error_message" ]; then
        echo -e "${RED}[ERROR] Error message is required.${NC}"
        echo "Usage: ai_debug_help \"<error_message>\""
        return 1
    fi
    
    echo -e "${YELLOW}[INFO] Getting debugging help from Gemini CLI...${NC}"
    echo ""
    
    gemini "I encountered this error in a shell script: '$error_message'. Explain what might be causing it and provide specific solutions with code examples."
}

# Example 9: Analyze log files
ai_analyze_logs() {
    local log_file="$1"
    
    if [ -z "$log_file" ]; then
        echo -e "${RED}[ERROR] Log file path is required.${NC}"
        echo "Usage: ai_analyze_logs <log_file>"
        return 1
    fi
    
    if [ ! -f "$log_file" ]; then
        echo -e "${RED}[ERROR] Log file not found: $log_file${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}[INFO] Analyzing log file: $log_file...${NC}"
    echo ""
    
    gemini "Analyze this log file, identify errors, warnings, and patterns. Summarize the key issues and provide recommendations." --file "$log_file"
}

# Example 10: Generate test cases
ai_generate_tests() {
    local file_path="$1"
    
    if [ -z "$file_path" ]; then
        echo -e "${RED}[ERROR] File path is required.${NC}"
        echo "Usage: ai_generate_tests <file_path>"
        return 1
    fi
    
    if [ ! -f "$file_path" ]; then
        echo -e "${RED}[ERROR] File not found: $file_path${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}[INFO] Generating test cases for $file_path...${NC}"
    echo ""
    
    gemini "Generate comprehensive test cases for this script. Include unit tests, edge cases, and integration test scenarios. Use appropriate testing framework syntax." --file "$file_path"
}

# Display usage information
echo -e "${CYAN}Available Functions:${NC}"
echo ""
echo -e "${WHITE}  ai_commit${NC}"
echo -e "${GRAY}    - Auto-generate git commit messages based on staged changes${NC}"
echo ""
echo -e "${WHITE}  ai_review <file_path>${NC}"
echo -e "${GRAY}    - Get AI code review for a shell script${NC}"
echo ""
echo -e "${WHITE}  ai_document <file_path> [output_path]${NC}"
echo -e "${GRAY}    - Generate documentation for a script${NC}"
echo ""
echo -e "${WHITE}  ai_explain_history [count]${NC}"
echo -e "${GRAY}    - Get AI summary of recent git commits (default: 10)${NC}"
echo ""
echo -e "${WHITE}  ai_security_audit <file_path>${NC}"
echo -e "${GRAY}    - Run security audit on a script${NC}"
echo ""
echo -e "${WHITE}  ai_optimize <file_path>${NC}"
echo -e "${GRAY}    - Get optimization suggestions for code${NC}"
echo ""
echo -e "${WHITE}  ai_document_all_scripts [directory] [output_directory]${NC}"
echo -e "${GRAY}    - Generate docs for all scripts in a directory${NC}"
echo ""
echo -e "${WHITE}  ai_debug_help \"<error_message>\"${NC}"
echo -e "${GRAY}    - Get help debugging an error message${NC}"
echo ""
echo -e "${WHITE}  ai_analyze_logs <log_file>${NC}"
echo -e "${GRAY}    - Analyze log file for errors and patterns${NC}"
echo ""
echo -e "${WHITE}  ai_generate_tests <file_path>${NC}"
echo -e "${GRAY}    - Generate test cases for a script${NC}"
echo ""
echo -e "${CYAN}=====================================================${NC}"
echo -e "${YELLOW}To use these functions, source this script:${NC}"
echo -e "${WHITE}source ./gemini-cli-integration.sh${NC}"
echo -e "${CYAN}=====================================================${NC}"
echo ""
