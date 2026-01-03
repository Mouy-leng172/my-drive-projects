# GitHub Fork Instructions - Web-Dev-For-Beginners

## Quick Reference

**Source Repository**: https://github.com/microsoft/Web-Dev-For-Beginners
**Target Fork Chain**: Microsoft → mouyleng/GenX_FX → A6-9V/my-drive-projects

## Step-by-Step Fork Instructions

### Part 1: Fork to mouyleng/GenX_FX

#### 1.1. Navigate to Microsoft Repository

1. Open your browser
2. Go to: https://github.com/microsoft/Web-Dev-For-Beginners
3. Make sure you see the Microsoft repository page with:
   - 24 Lessons, 12 Weeks, Get Started as a Web Developer
   - MIT License badge
   - Fork and Star buttons

#### 1.2. Create Fork to mouyleng Account

1. **Click the "Fork" button** (top-right corner, next to Star)
2. You'll see the "Create a new fork" page
3. **Configure the fork**:
   - **Owner**: Select `mouyleng` from the dropdown
   - **Repository name**: `GenX_FX`
   - **Description**: "GenX FX customization of Microsoft's Web-Dev-For-Beginners curriculum"
   - **Copy the main branch only**: ✅ (checked) - recommended
4. **Click "Create fork"** button

#### 1.3. Verify First Fork

After creation, you should see:
- URL: https://github.com/mouyleng/GenX_FX
- Badge showing: "forked from microsoft/Web-Dev-For-Beginners"
- All the lessons and content from the original repository

### Part 2: Integrate with A6-9V/my-drive-projects

You have three options for the second step:

#### Option A: Fork to A6-9V Organization (Recommended)

1. **Navigate to**: https://github.com/mouyleng/GenX_FX
2. **Click the "Fork" button** again
3. **Configure the fork**:
   - **Owner**: Select `A6-9V` organization
   - **Repository name**: `GenX_FX` or `Web-Dev-For-Beginners`
   - **Description**: "Web development learning integrated with A6-9V automation projects"
   - **Copy the main branch only**: ✅ (checked)
4. **Click "Create fork"**

Result: https://github.com/A6-9V/GenX_FX (or Web-Dev-For-Beginners)

#### Option B: Add as Git Submodule (Alternative)

If you prefer to keep it as a reference in my-drive-projects:

1. **Open PowerShell as Administrator** on your local machine
2. **Navigate to** the my-drive-projects directory:
   ```powershell
   cd path\to\my-drive-projects
   ```
3. **Run the setup script**:
   ```powershell
   .\setup-web-dev-fork.ps1 -Method submodule
   ```
4. **Commit the changes**:
   ```powershell
   git add .gitmodules projects/Web-Dev-For-Beginners
   git commit -m "Add Web-Dev-For-Beginners as submodule from mouyleng/GenX_FX"
   git push
   ```

#### Option C: Clone Locally (Simplest)

If you just want to work with it locally:

1. **Open PowerShell as Administrator**
2. **Navigate to** the my-drive-projects directory:
   ```powershell
   cd path\to\my-drive-projects
   ```
3. **Run the setup script**:
   ```powershell
   .\setup-web-dev-fork.ps1 -Method clone
   ```
4. **Add to .gitignore** if you don't want to track it:
   ```powershell
   Add-Content .gitignore "`nprojects/Web-Dev-For-Beginners/"
   ```

## Post-Fork Configuration

### Set Up Remote Tracking

After forking, configure remote repositories to track upstream changes:

#### For mouyleng/GenX_FX Repository

```bash
# Clone your fork
git clone https://github.com/mouyleng/GenX_FX.git
cd GenX_FX

# Add upstream remote (Microsoft's original)
git remote add upstream https://github.com/microsoft/Web-Dev-For-Beginners.git

# Verify remotes
git remote -v
# Should show:
# origin    https://github.com/mouyleng/GenX_FX.git (fetch)
# origin    https://github.com/mouyleng/GenX_FX.git (push)
# upstream  https://github.com/microsoft/Web-Dev-For-Beginners.git (fetch)
# upstream  https://github.com/microsoft/Web-Dev-For-Beginners.git (push)
```

#### For A6-9V Fork (if using Option A)

```bash
# Clone the A6-9V fork
git clone https://github.com/A6-9V/GenX_FX.git
cd GenX_FX

# Add both upstream remotes
git remote add genx https://github.com/mouyleng/GenX_FX.git
git remote add microsoft https://github.com/microsoft/Web-Dev-For-Beginners.git

# Verify remotes
git remote -v
# Should show:
# origin      https://github.com/A6-9V/GenX_FX.git (fetch)
# origin      https://github.com/A6-9V/GenX_FX.git (push)
# genx        https://github.com/mouyleng/GenX_FX.git (fetch)
# genx        https://github.com/mouyleng/GenX_FX.git (push)
# microsoft   https://github.com/microsoft/Web-Dev-For-Beginners.git (fetch)
# microsoft   https://github.com/microsoft/Web-Dev-For-Beginners.git (push)
```

### Sync with Upstream

To keep your forks updated with the latest from Microsoft:

#### Update mouyleng/GenX_FX from Microsoft

```bash
cd /path/to/GenX_FX

# Fetch latest changes from Microsoft
git fetch upstream

# Switch to main branch
git checkout main

# Merge changes
git merge upstream/main

# Push to your fork
git push origin main
```

#### Update A6-9V fork from mouyleng

```bash
cd /path/to/A6-9V-GenX_FX

# Fetch latest from mouyleng
git fetch genx

# Switch to main branch
git checkout main

# Merge changes
git merge genx/main

# Push to A6-9V
git push origin main
```

## Verification Checklist

After completing the fork process:

- [ ] **mouyleng/GenX_FX exists** on GitHub
  - URL: https://github.com/mouyleng/GenX_FX
  - Shows "forked from microsoft/Web-Dev-For-Beginners"
  
- [ ] **A6-9V integration complete** (choose one):
  - [ ] Fork exists at https://github.com/A6-9V/GenX_FX
  - [ ] Submodule added to my-drive-projects
  - [ ] Cloned locally to projects/Web-Dev-For-Beginners

- [ ] **Remote tracking configured**
  - [ ] mouyleng/GenX_FX tracks Microsoft upstream
  - [ ] A6-9V fork tracks mouyleng and Microsoft

- [ ] **Documentation updated**
  - [ ] WEB-DEV-FOR-BEGINNERS-FORK-GUIDE.md exists
  - [ ] README.md mentions the project
  - [ ] setup-web-dev-fork.ps1 script available

## Common Issues and Solutions

### Issue: Fork Button Disabled

**Cause**: You might already have a fork of this repository

**Solution**:
1. Check if you already forked it: https://github.com/mouyleng?tab=repositories
2. If exists, rename the old fork or delete it
3. Then create the new fork with the desired name

### Issue: "A repository with this name already exists"

**Solution**:
1. Choose a different repository name (e.g., `GenX_FX-Web-Dev`)
2. Or delete the existing repository (if it's a duplicate)
3. Update the repository name in the documentation

### Issue: Cannot See Organization in Fork Options

**Solution**:
1. Make sure you're a member of the A6-9V organization
2. Check your organization membership: https://github.com/orgs/A6-9V/people
3. You need at least write access to fork to the organization

### Issue: Submodule Won't Update

**Solution**:
```bash
# Remove and re-add the submodule
git submodule deinit projects/Web-Dev-For-Beginners
git rm projects/Web-Dev-For-Beginners
git submodule add https://github.com/mouyleng/GenX_FX projects/Web-Dev-For-Beginners
git submodule update --init --recursive
```

## Next Steps After Forking

1. **Review the Curriculum**
   - Visit: https://microsoft.github.io/Web-Dev-For-Beginners/
   - Review all 24 lessons
   - Plan your learning schedule (12 weeks)

2. **Start Learning**
   - Begin with Week 1: Getting Started with Programming
   - Complete exercises and quizzes
   - Build the projects

3. **Customize for GenX_FX**
   - Add trading-related examples
   - Integrate with A6-9V automation concepts
   - Create custom exercises

4. **Apply to A6-9V Projects**
   - Use learnings for VPS dashboard interfaces
   - Build trading system web interfaces
   - Create documentation websites

## Support and Resources

- **Original Curriculum**: https://microsoft.github.io/Web-Dev-For-Beginners/
- **Fork Guide**: WEB-DEV-FOR-BEGINNERS-FORK-GUIDE.md
- **Setup Script**: setup-web-dev-fork.ps1
- **GitHub Docs**: https://docs.github.com/en/get-started/quickstart/fork-a-repo

## Last Updated

2026-01-03
