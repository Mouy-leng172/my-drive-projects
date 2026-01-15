# Web-Dev-For-Beginners Fork Guide

## Overview

This guide documents the process of forking Microsoft's Web-Dev-For-Beginners repository through a specific fork chain for the A6-9V project ecosystem.

## Source Repository

**Microsoft Web Dev For Beginners**
- **Repository URL**: https://github.com/microsoft/Web-Dev-For-Beginners
- **Website**: https://microsoft.github.io/Web-Dev-For-Beginners/
- **Description**: 24 Lessons, 12 Weeks, Get Started as a Web Developer
- **License**: MIT License

## Fork Chain Strategy

The forking process follows this specific chain to maintain project organization and proper attribution:

```
┌────────────────────────────────────────────────────┐
│  Microsoft/Web-Dev-For-Beginners (Original)        │
│  https://github.com/microsoft/Web-Dev-For-Beginners│
└────────────────────┬───────────────────────────────┘
                     │
                     │ Fork #1
                     ▼
┌────────────────────────────────────────────────────┐
│  mouyleng/GenX_FX (Intermediate Fork)              │
│  First fork for GenX FX project customization      │
└────────────────────┬───────────────────────────────┘
                     │
                     │ Fork #2
                     ▼
┌────────────────────────────────────────────────────┐
│  A6-9V/my-drive-projects (Final Integration)       │
│  Integration into A6-9V project ecosystem          │
└────────────────────────────────────────────────────┘
```

## Forking Steps

### Step 1: Fork to mouyleng/GenX_FX

1. **Navigate to the original repository**:
   - Go to https://github.com/microsoft/Web-Dev-For-Beginners

2. **Create the first fork**:
   - Click the "Fork" button in the top-right corner
   - Select the `mouyleng` account as the owner
   - Name the repository: `GenX_FX`
   - Keep the default branch name
   - Click "Create fork"

3. **Verify the fork**:
   - Repository will be created at: `https://github.com/mouyleng/GenX_FX`
   - Should show "forked from microsoft/Web-Dev-For-Beginners"

### Step 2: Fork to A6-9V/my-drive-projects

**Option A: Fork as Submodule (Recommended)**

1. **Add as Git submodule** in the my-drive-projects repository:
   ```bash
   cd /path/to/my-drive-projects
   git submodule add https://github.com/mouyleng/GenX_FX.git projects/Web-Dev-For-Beginners
   git submodule update --init --recursive
   ```

2. **Commit the submodule**:
   ```bash
   git add .gitmodules projects/Web-Dev-For-Beginners
   git commit -m "Add Web-Dev-For-Beginners as submodule from mouyleng/GenX_FX"
   git push
   ```

**Option B: Fork to Organization**

1. **Navigate to the intermediate fork**:
   - Go to https://github.com/mouyleng/GenX_FX

2. **Create the second fork**:
   - Click the "Fork" button
   - Select the `A6-9V` organization as the owner
   - Choose "Copy the main branch only" (unless you need all branches)
   - Click "Create fork"

3. **Verify the organization fork**:
   - Repository will be at: `https://github.com/A6-9V/GenX_FX`
   - Should show "forked from mouyleng/GenX_FX"

**Option C: Clone and Reference**

1. **Clone into projects directory**:
   ```bash
   cd projects
   git clone https://github.com/mouyleng/GenX_FX.git Web-Dev-For-Beginners
   ```

2. **Track the fork relationship**:
   - Document the fork chain in this file
   - Add remote tracking in the cloned repository

## Post-Fork Configuration

### Update Fork Relationships

1. **In mouyleng/GenX_FX repository**:
   ```bash
   cd /path/to/GenX_FX
   git remote add upstream https://github.com/microsoft/Web-Dev-For-Beginners.git
   git remote -v
   ```

2. **In A6-9V fork (if using Option B)**:
   ```bash
   cd /path/to/A6-9V-GenX_FX
   git remote add upstream https://github.com/mouyleng/GenX_FX.git
   git remote add original https://github.com/microsoft/Web-Dev-For-Beginners.git
   git remote -v
   ```

### Sync with Upstream

To keep forks updated with the original repository:

```bash
# Update mouyleng/GenX_FX from Microsoft
cd /path/to/GenX_FX
git fetch upstream
git checkout main
git merge upstream/main
git push origin main

# Update A6-9V fork from mouyleng
cd /path/to/A6-9V-fork
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

## Integration with my-drive-projects

### Project Structure

```
my-drive-projects/
├── projects/
│   ├── Google AI Studio/
│   ├── LiteWriter/
│   └── Web-Dev-For-Beginners/  ← New project location
│       ├── 1-getting-started-lessons/
│       ├── 2-js-basics/
│       ├── 3-terrarium/
│       ├── 4-typing-game/
│       ├── 5-browser-extension/
│       ├── 6-space-game/
│       ├── 7-bank-project/
│       └── sketchnotes/
└── WEB-DEV-FOR-BEGINNERS-FORK-GUIDE.md  ← This file
```

### Documentation Updates

Add reference to README.md:

```markdown
### Web Development Learning

The repository includes Microsoft's Web-Dev-For-Beginners curriculum:
- 24 Lessons covering HTML, CSS, JavaScript
- 12 Weeks of structured learning
- Hands-on projects and exercises
- Located in: `projects/Web-Dev-For-Beginners/`

**Fork Chain**: Microsoft → mouyleng/GenX_FX → A6-9V
```

## Customization Strategy

### GenX_FX Customizations (mouyleng)

The intermediate fork (mouyleng/GenX_FX) can include:
- GenX FX project-specific modifications
- Custom exercises and examples
- Trading/finance-related web development examples
- Integration with trading systems concepts

### A6-9V Integration

The final integration into A6-9V/my-drive-projects includes:
- Integration with existing automation scripts
- Workspace configuration for Cursor IDE
- Connection to VPS trading system concepts
- Documentation in DEVICE-SKELETON.md

## Maintenance

### Regular Updates

1. **Weekly sync** from Microsoft repository:
   - Check for new lessons or updates
   - Merge upstream changes to mouyleng/GenX_FX
   - Propagate changes to A6-9V fork

2. **Version tagging**:
   - Tag major updates: `v1.0`, `v2.0`, etc.
   - Document custom changes in CHANGELOG

### Contributing Back

If creating valuable improvements:
1. Submit pull requests to mouyleng/GenX_FX
2. Consider contributing to Microsoft's original repository
3. Follow Microsoft's contribution guidelines

## Repository Links

| Repository | URL | Purpose |
|------------|-----|---------|
| **Original** | https://github.com/microsoft/Web-Dev-For-Beginners | Microsoft's official curriculum |
| **GenX_FX Fork** | https://github.com/mouyleng/GenX_FX | Intermediate fork with GenX customizations |
| **A6-9V Integration** | Part of https://github.com/A6-9V/my-drive-projects | Final integration in project ecosystem |

## Learning Path Integration

### Recommended Usage

1. **Follow the curriculum** in sequence (Weeks 1-12)
2. **Complete projects** within the lessons
3. **Apply learnings** to A6-9V projects:
   - VPS service web interfaces
   - Trading dashboard development
   - GitHub Pages websites
   - Automation tool interfaces

### Project Connections

| Web-Dev Lesson | A6-9V Application |
|----------------|-------------------|
| HTML/CSS Basics | Trading dashboard UI |
| JavaScript | Automation scripts frontend |
| Browser APIs | System monitoring interfaces |
| Forms & Validation | Trading configuration forms |
| API Integration | Broker API dashboards |
| Deployment | GitHub Pages deployment |

## Troubleshooting

### Fork Not Showing Upstream

If the fork relationship isn't visible:
```bash
git remote -v
git remote add upstream <parent-repo-url>
git fetch upstream
```

### Merge Conflicts

When syncing with upstream:
1. Backup custom changes
2. Create a new branch for merge conflicts
3. Resolve conflicts manually
4. Test thoroughly before merging to main

### Submodule Issues

If using as submodule and having issues:
```bash
git submodule update --init --recursive
git submodule sync
git submodule update --remote
```

## Additional Resources

- **Original Curriculum**: https://microsoft.github.io/Web-Dev-For-Beginners/
- **Microsoft Learn**: https://learn.microsoft.com/
- **GitHub Docs - Forking**: https://docs.github.com/en/get-started/quickstart/fork-a-repo
- **Git Submodules**: https://git-scm.com/book/en/v2/Git-Tools-Submodules

## Status

- [x] Documentation created
- [ ] Fork to mouyleng/GenX_FX completed
- [ ] Fork/Integration to A6-9V completed
- [ ] Project structure updated
- [ ] README updated with references

## Last Updated

2026-01-03
