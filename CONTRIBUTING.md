# Contributing to A6-9V/my-drive-projects

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Submitting Changes](#submitting-changes)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inspiring community for everyone. Please be respectful and constructive in all interactions.

### Expected Behavior

- Use welcoming and inclusive language
- Be respectful of differing viewpoints
- Accept constructive criticism gracefully
- Focus on what is best for the community
- Show empathy towards others

### Unacceptable Behavior

- Harassment or discriminatory language
- Trolling or insulting comments
- Public or private harassment
- Publishing others' private information
- Other conduct which could reasonably be considered inappropriate

## How Can I Contribute?

### Reporting Bugs

Before creating a bug report:
1. Check existing issues to avoid duplicates
2. Collect relevant information (see template below)
3. Verify the issue is reproducible

**Bug Report Template:**
```markdown
**Description:**
Brief description of the issue

**Steps to Reproduce:**
1. Step one
2. Step two
3. ...

**Expected Behavior:**
What should happen

**Actual Behavior:**
What actually happens

**Environment:**
- OS: Windows 11 Build XXXXX
- PowerShell Version: X.X
- Python Version: X.X.X
- Relevant software versions

**Logs/Screenshots:**
Any relevant error messages or screenshots

**Additional Context:**
Any other information that might help
```

### Suggesting Enhancements

Enhancement suggestions are welcome! Please:
1. Use a clear and descriptive title
2. Provide detailed description of the proposed enhancement
3. Explain why this would be useful
4. Include examples of how it would work

### Contributing Code

Types of contributions we're looking for:
- Bug fixes
- New features
- Documentation improvements
- Performance enhancements
- Test coverage improvements
- Security enhancements

## Development Setup

### Prerequisites

Ensure you have installed:
- Windows 11 or Windows 10 (Build 19041+)
- PowerShell 5.1+
- Git
- Python 3.8+
- A code editor (VS Code or Cursor recommended)

### Setup Steps

1. **Fork the repository**
   ```bash
   # On GitHub, click "Fork" button
   ```

2. **Clone your fork**
   ```powershell
   git clone https://github.com/YOUR_USERNAME/my-drive-projects.git
   cd my-drive-projects
   ```

3. **Add upstream remote**
   ```powershell
   git remote add upstream https://github.com/A6-9V/my-drive-projects.git
   ```

4. **Create a branch**
   ```powershell
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bug-fix
   ```

5. **Set up development environment**
   ```powershell
   # Run validation
   .\validate-setup.ps1
   
   # Create Python virtual environment
   python -m venv venv
   .\venv\Scripts\Activate.ps1
   
   # Install dependencies
   pip install -r trading-bridge\requirements.txt
   ```

## Coding Standards

### PowerShell Scripts

**Style Guidelines:**
```powershell
# Use clear, descriptive variable names
$userName = "John"  # Good
$u = "John"         # Bad

# Add comments for complex logic
# Calculate trading position size based on risk
$positionSize = ($accountBalance * $riskPercent) / $stopLossPips

# Use proper error handling
try {
    Invoke-RestMethod -Uri $apiUrl
} catch {
    Write-Error "API call failed: $_"
    exit 1
}

# Use consistent status indicators
Write-Host "[OK] Operation successful" -ForegroundColor Green
Write-Host "[ERROR] Operation failed" -ForegroundColor Red
Write-Host "[WARNING] Potential issue" -ForegroundColor Yellow
Write-Host "[INFO] Information" -ForegroundColor Cyan
```

**Best Practices:**
- Always use try-catch blocks for risky operations
- Validate user input before processing
- Use `Test-Path` before accessing files
- Provide helpful error messages
- Use `Write-Host` with colors for user feedback

### Python Code

**Style Guidelines:**
```python
# Follow PEP 8
# Use descriptive names
def calculate_position_size(balance, risk_percent, stop_loss):
    """
    Calculate position size based on risk management rules.
    
    Args:
        balance: Account balance
        risk_percent: Risk as percentage (1-5)
        stop_loss: Stop loss in pips
    
    Returns:
        float: Position size in lots
    """
    return (balance * risk_percent / 100) / stop_loss

# Type hints recommended
from typing import Dict, List, Optional

def get_broker_config(broker_name: str) -> Optional[Dict]:
    """Get broker configuration."""
    pass
```

**Best Practices:**
- Use type hints where appropriate
- Write docstrings for functions and classes
- Follow PEP 8 style guide
- Use meaningful variable names
- Add unit tests for new features

### Documentation

**Markdown Standards:**
- Use clear headings (# ## ###)
- Include code examples
- Add links to related documentation
- Keep lines under 120 characters when possible
- Use lists for clarity

**Code Comments:**
- Explain WHY, not WHAT (code should be self-explanatory)
- Update comments when code changes
- Use TODO/FIXME/NOTE markers appropriately

### Security

**Critical Rules:**
- Never commit credentials or tokens
- Always validate and sanitize user input
- Use parameterized queries/commands
- Keep dependencies updated
- Follow principle of least privilege

**Security Checklist:**
- [ ] No hardcoded credentials
- [ ] Input validation implemented
- [ ] Error messages don't leak sensitive info
- [ ] Config files are gitignored
- [ ] HTTPS used for API calls
- [ ] Proper authentication and authorization

## Submitting Changes

### Pull Request Process

1. **Update your fork**
   ```powershell
   git fetch upstream
   git checkout main
   git merge upstream/main
   ```

2. **Create feature branch**
   ```powershell
   git checkout -b feature/your-feature
   ```

3. **Make your changes**
   - Write clear, concise commits
   - Follow coding standards
   - Add tests if applicable
   - Update documentation

4. **Test your changes**
   ```powershell
   # Run validation
   .\validate-setup.ps1
   
   # Test your specific changes
   # Run affected scripts
   # Check for errors
   ```

5. **Commit your changes**
   ```powershell
   git add .
   git commit -m "feat: add new feature description"
   # or
   git commit -m "fix: resolve issue with X"
   ```

   **Commit Message Format:**
   ```
   type: brief description
   
   Longer explanation if needed.
   
   Fixes #issue-number
   ```

   **Types:**
   - `feat`: New feature
   - `fix`: Bug fix
   - `docs`: Documentation changes
   - `style`: Code style changes (formatting)
   - `refactor`: Code refactoring
   - `test`: Adding tests
   - `chore`: Maintenance tasks

6. **Push to your fork**
   ```powershell
   git push origin feature/your-feature
   ```

7. **Create Pull Request**
   - Go to GitHub and create PR
   - Use clear title and description
   - Reference related issues
   - Wait for review

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Security enhancement

## Testing
How you tested the changes

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Tests added/updated (if applicable)
- [ ] Security considerations addressed

## Related Issues
Fixes #(issue number)
```

### Review Process

1. Maintainers will review your PR
2. Address any feedback or requested changes
3. Once approved, PR will be merged
4. Your contribution will be acknowledged!

## Testing

### Manual Testing

```powershell
# Run setup validation
.\validate-setup.ps1

# Test specific scripts
.\your-script.ps1

# Check for errors in logs
Get-ChildItem *.log | Select-String "ERROR"
```

### Automated Testing

GitHub Actions will automatically:
- Validate syntax
- Check security issues
- Verify documentation
- Run integration tests

Ensure your changes pass all checks.

## Style Guide Quick Reference

### PowerShell
- Use `PascalCase` for function names
- Use `$camelCase` for variables
- Indent with 4 spaces
- Use meaningful names
- Add parameter validation

### Python
- Follow PEP 8
- Use `snake_case` for functions/variables
- Use `PascalCase` for classes
- Indent with 4 spaces
- Maximum line length: 88 characters (Black formatter)

### Markdown
- Use `#` for h1, `##` for h2, etc.
- Use fenced code blocks with language tags
- Use `-` for unordered lists
- Use `1.` for ordered lists

## Questions?

If you have questions:
1. Check existing documentation
2. Search closed issues
3. Ask in GitHub Discussions
4. Create a new issue with the "question" label

## Recognition

Contributors will be:
- Listed in README (if desired)
- Credited in release notes
- Mentioned in commit history
- Part of the community!

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

**Thank you for contributing!**

We appreciate your time and effort in making this project better for everyone.

**Last Updated**: 2026-01-02  
**Maintained by**: A6-9V Organization
