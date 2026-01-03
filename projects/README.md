# Projects Directory

This directory contains active development projects integrated with the A6-9V automation ecosystem.

## Current Projects

### 1. Google AI Studio
AI Studio related projects and integrations.

**Location**: `Google AI Studio/`

### 2. Web-Dev-For-Beginners (NEW)
Microsoft's comprehensive web development curriculum, forked through mouyleng/GenX_FX.

**Status**: Documentation created, fork pending
**Location**: `Web-Dev-For-Beginners/` (after setup)
**Source**: https://github.com/mouyleng/GenX_FX (fork of microsoft/Web-Dev-For-Beginners)

**Setup Instructions**:
```powershell
# From repository root
.\setup-web-dev-fork.ps1
```

**Fork Chain**: Microsoft → mouyleng/GenX_FX → A6-9V

**Content**:
- 24 Lessons: HTML, CSS, JavaScript
- 12 Weeks of structured learning
- Hands-on projects: Terrarium, Typing Game, Browser Extension, Space Game, Bank Project
- Complete curriculum website: https://microsoft.github.io/Web-Dev-For-Beginners/

**Integration Goals**:
- Build VPS dashboard interfaces
- Create trading system web UIs
- Develop GitHub Pages websites
- Design automation tool interfaces

**Documentation**:
- Quick Start: `../WEB-DEV-QUICK-START.md`
- Detailed Guide: `../WEB-DEV-FOR-BEGINNERS-FORK-GUIDE.md`
- Fork Instructions: `../GITHUB-FORK-INSTRUCTIONS.md`

## Adding New Projects

When adding new projects to this directory:

1. **Create project directory**:
   ```bash
   mkdir "projects/ProjectName"
   ```

2. **Clone or initialize**:
   ```bash
   cd "projects/ProjectName"
   git clone [repository-url] .
   # or
   git init
   ```

3. **Document in this README**:
   - Add project name
   - Add description
   - Add location
   - Add setup instructions

4. **Update main README**:
   - Add to project structure section
   - Add to features if applicable

## Project Guidelines

- ✅ Each project should have its own README
- ✅ Follow the A6-9V automation patterns
- ✅ Use PowerShell for Windows automation
- ✅ Document integration points
- ✅ Include setup scripts where appropriate

## Integration with Main Repository

All projects in this directory are part of the larger my-drive-projects ecosystem and should:
- Use shared automation scripts from the root
- Follow security guidelines (no credentials in code)
- Integrate with VPS services where applicable
- Support the overall A6-9V project goals

## Last Updated

2026-01-03
