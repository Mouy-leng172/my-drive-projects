# Security Policy

## Overview

The A6-9V/my-drive-projects repository contains automation scripts, trading systems, and infrastructure management tools. Security is paramount, especially when dealing with:
- Financial trading APIs
- Broker credentials
- Personal data
- Cloud service integrations
- System automation

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |
| < 1.0   | :x:                |

Currently, only the latest version on the `main` branch receives security updates.

## Reporting a Vulnerability

### How to Report

If you discover a security vulnerability, please follow these steps:

1. **DO NOT** create a public GitHub issue
2. **DO NOT** disclose the vulnerability publicly
3. **DO** email security details to the repository maintainer
4. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### Response Time

- **Initial Response**: Within 48 hours
- **Status Update**: Within 7 days
- **Fix Timeline**: Depends on severity (see below)

### Severity Levels

| Severity | Description | Response Time |
|----------|-------------|---------------|
| Critical | Credential exposure, RCE | 24 hours |
| High | Data leak, privilege escalation | 72 hours |
| Medium | Information disclosure | 7 days |
| Low | Minor issues | 14 days |

## Security Best Practices

### For Users

#### Credential Management

**✅ DO:**
- Use GitHub CLI (`gh auth login`) for OAuth authentication
- Store credentials in Windows Credential Manager
- Use `.env` files for local configuration (gitignored)
- Rotate API keys regularly
- Use separate credentials for development and production
- Enable two-factor authentication on all accounts

**❌ DON'T:**
- Never commit credentials to Git
- Never share API keys via email or chat
- Don't reuse passwords across services
- Don't store credentials in plain text files
- Don't disable security features for convenience

#### Configuration Files

**Protected Files** (automatically gitignored):
```
.env
.env.local
*.token
*.secret
*credentials*
git-credentials.txt
brokers.json
symbols.json
mql_io.json
*.pem
*.key
```

**Always verify** these files are NOT committed:
```powershell
# Check git status
git status

# Verify gitignore is working
git check-ignore .env
git check-ignore trading-bridge/config/brokers.json
```

#### Windows Security

**Enable Essential Protections:**
- Windows Defender (don't disable)
- Windows Firewall (configured by setup scripts)
- Controlled Folder Access (for cloud sync folders)
- SmartScreen (for download protection)

**Keep Updated:**
- Windows Updates (monthly security patches)
- PowerShell (latest stable version)
- Python and pip (regularly update)
- Git (update when available)

### For Developers

#### Code Security

**Secure Coding Practices:**

1. **Input Validation**
   ```powershell
   # Validate user input
   if (-not (Test-Path $UserInput)) {
       Write-Error "Invalid path"
       exit 1
   }
   ```

2. **Avoid Command Injection**
   ```powershell
   # BAD - Command injection risk
   Invoke-Expression "git commit -m '$UserMessage'"
   
   # GOOD - Use parameters
   git commit -m $UserMessage
   ```

3. **Secure API Calls**
   ```python
   # Use environment variables
   import os
   api_key = os.getenv('EXNESS_API_KEY')
   
   # Never hardcode credentials
   # api_key = "abc123"  # DON'T DO THIS
   ```

4. **Error Handling**
   ```powershell
   try {
       # Risky operation
       Invoke-RestMethod -Uri $api_url
   } catch {
       # Don't expose sensitive details in errors
       Write-Error "API call failed"
       Write-Debug $_.Exception.Message
   }
   ```

#### Dependency Security

**Python Dependencies:**
```powershell
# Check for vulnerabilities
pip list --outdated

# Update dependencies
pip install --upgrade -r trading-bridge\requirements.txt

# Audit dependencies (if pip-audit is installed)
pip-audit
```

**GitHub Actions:**
- Use pinned versions for actions
- Enable Dependabot for automated security updates
- Review dependency updates before merging

#### Code Review

**Security Checklist:**
- [ ] No hardcoded credentials
- [ ] No sensitive data in logs
- [ ] Input validation implemented
- [ ] Error messages don't leak information
- [ ] Configuration files are gitignored
- [ ] API calls use HTTPS
- [ ] Timeouts configured for network calls
- [ ] Rate limiting implemented

## Security Features

### Automated Security

This repository includes:

1. **Pre-commit Checks** (via .gitignore)
   - Blocks credential files
   - Prevents sensitive data commits
   - Filters large binary files

2. **Security Validation Scripts**
   ```powershell
   # Run security check
   .\security-check.ps1
   
   # Trading system security
   .\security-check-trading.ps1
   
   # VPS security check
   .\security-check-vps.ps1
   ```

3. **Configuration Validation**
   ```powershell
   # Validate setup
   .\validate-setup.ps1
   ```

### Windows Credential Manager Integration

Credentials are automatically moved to Windows Credential Manager after first use:

```powershell
# Store credential
cmdkey /generic:github_token /user:username /pass:token

# Retrieve credential
$cred = Get-StoredCredential -Target github_token
```

### Firewall Configuration

Automated firewall rules for:
- Trading Bridge (port 5500)
- Cloud sync services
- Remote Desktop (if enabled)

```powershell
# Configure firewall
.\setup-network-firewall.ps1

# Verify firewall rules
Get-NetFirewallRule | Where-Object DisplayName -like "*Trading*"
```

## Network Security

### Required Ports

| Port | Service | Direction | Security |
|------|---------|-----------|----------|
| 443 | HTTPS | Outbound | TLS 1.2+ |
| 5500 | Trading Bridge | Both | localhost only |
| 3389 | RDP (optional) | Inbound | Restricted IP |

### Firewall Rules

**Trading Bridge:**
- Port 5500 should only accept localhost connections
- Block external access to trading bridge

**Remote Access:**
- Use VPN for remote access when possible
- Restrict RDP to specific IP addresses
- Use strong passwords and 2FA

## Data Protection

### Sensitive Data Types

1. **API Credentials**
   - Broker API keys and secrets
   - GitHub tokens
   - Cloud service credentials

2. **Trading Data**
   - Account numbers
   - Trading strategies
   - Performance metrics

3. **Personal Information**
   - Email addresses
   - Account identifiers
   - System configurations

### Data Storage

**Local Storage:**
- Credentials: Windows Credential Manager
- Configuration: `.env` files (gitignored)
- Logs: Redacted, no sensitive data

**Cloud Storage:**
- Never store credentials in cloud sync folders
- Use encryption for sensitive documents
- Review OneDrive/Google Drive sharing settings

### Data Transmission

**In Transit:**
- Always use HTTPS for API calls
- TLS 1.2 or higher
- Verify SSL certificates

**At Rest:**
- Windows BitLocker (recommended)
- Encrypted containers for sensitive files
- Secure deletion of old credentials

## Incident Response

### If Credentials Are Compromised

1. **Immediate Actions:**
   ```powershell
   # Remove from Git history (if committed)
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch path/to/sensitive/file" \
     --prune-empty --tag-name-filter cat -- --all
   
   # Force push (if absolutely necessary)
   git push origin --force --all
   ```

2. **Revoke Compromised Credentials:**
   - GitHub: Revoke PAT at github.com/settings/tokens
   - Broker: Revoke API keys in broker dashboard
   - Cloud Services: Change passwords, revoke access

3. **Generate New Credentials:**
   - Create new API keys
   - Update local configuration
   - Update production systems
   - Test connectivity

4. **Audit Access:**
   - Check GitHub access logs
   - Review broker account activity
   - Check for unauthorized trades
   - Review system logs

### If System Is Compromised

1. **Disconnect from network**
2. **Stop all trading activities**
3. **Run security scan**
   ```powershell
   # Windows Defender full scan
   Start-MpScan -ScanType FullScan
   ```
4. **Review logs for suspicious activity**
5. **Change all credentials**
6. **Restore from clean backup**

## Compliance

### Personal Use

This repository is primarily for personal use:
- No GDPR compliance required (personal data only)
- No financial regulations (personal trading)
- Follow broker terms of service

### If Used Professionally

If adapted for professional use, consider:
- Data protection regulations (GDPR, etc.)
- Financial regulations (depending on jurisdiction)
- Audit logging requirements
- Access control policies
- Disaster recovery plans

## Security Roadmap

### Planned Improvements

- [ ] Automated vulnerability scanning
- [ ] GitHub Advanced Security features
- [ ] Secrets scanning
- [ ] Dependency review
- [ ] Code scanning (CodeQL)
- [ ] Encrypted configuration files
- [ ] Hardware security key support
- [ ] Audit logging

### Community Contributions

We welcome security improvements:
- Vulnerability reports (private disclosure)
- Security feature suggestions
- Documentation improvements
- Best practices recommendations

## Resources

### External Links

- [GitHub Security Best Practices](https://docs.github.com/en/code-security)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Windows Security Documentation](https://docs.microsoft.com/en-us/windows/security/)
- [Python Security](https://python.readthedocs.io/en/stable/library/security_warnings.html)

### Internal Documentation

- `AUTOMATION-RULES.md` - Automation security patterns
- `GITHUB-SECRETS-SETUP.md` - Secure credential management
- `HOW-TO-RUN.md` - Secure setup procedures
- `PREREQUISITES.md` - Security requirements

## Contact

For security concerns:
- **Private**: Contact repository maintainer directly
- **Public**: General security questions in discussions
- **Emergency**: For critical vulnerabilities, follow reporting process

---

**Last Updated**: 2026-01-02  
**Version**: 1.0  
**Maintained by**: A6-9V Organization

**Remember**: Security is everyone's responsibility. When in doubt, ask!
