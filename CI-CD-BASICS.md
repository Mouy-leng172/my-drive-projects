# CI/CD Basics Guide

## 📚 What is CI/CD?

**CI/CD** stands for **Continuous Integration** and **Continuous Deployment/Delivery**. It's a modern software development practice that enables teams to deliver code changes more frequently, reliably, and with higher quality.

### Continuous Integration (CI)

**Continuous Integration** is the practice of automatically building and testing code changes whenever they are committed to the repository.

**Key Benefits:**
- ✅ Early detection of bugs and integration issues
- ✅ Faster feedback to developers
- ✅ Reduced integration problems
- ✅ Improved code quality
- ✅ Automated testing

**How it works:**
1. Developer commits code to version control (e.g., Git)
2. CI system automatically detects the change
3. CI system builds the code
4. CI system runs automated tests
5. CI system reports results (pass/fail)
6. Developers fix issues if tests fail

### Continuous Deployment/Delivery (CD)

**Continuous Deployment** is the practice of automatically deploying code changes to production after passing all tests.

**Continuous Delivery** is similar but requires manual approval before production deployment.

**Key Benefits:**
- ✅ Faster time to market
- ✅ Reduced deployment risk
- ✅ More frequent releases
- ✅ Automated deployment process
- ✅ Consistent deployments

**How it works:**
1. Code passes all CI tests
2. CD system packages the application
3. CD system deploys to staging environment
4. Automated tests run on staging
5. (Optional) Manual approval
6. CD system deploys to production
7. Monitor and verify deployment

## 🚀 CI/CD in This Repository

This repository uses **GitHub Actions** as the CI/CD platform. GitHub Actions provides:

- Free CI/CD for public repositories
- Native integration with GitHub
- Workflow automation
- Pre-built actions from the marketplace
- Support for multiple operating systems

### Current Workflows

#### 1. Auto-Merge Workflow (`.github/workflows/auto-merge.yml`)

**Purpose:** Automatically merges pull requests when all checks pass.

**Triggers:**
- Pull request opened, synchronized, or reopened
- Pull request review submitted
- Check suite completed
- Status changes

**Key Features:**
- ✅ Verifies PR is not a draft
- ✅ Checks PR is in mergeable state
- ✅ Verifies no changes requested
- ✅ Ensures all status checks pass
- ✅ Confirms all check runs pass
- ✅ Updates PR branch
- ✅ Merges PR automatically
- ✅ Deletes branch after merge

#### 2. Enable Auto-Merge Workflow (`.github/workflows/enable-auto-merge.yml`)

**Purpose:** Enables auto-merge feature for new pull requests.

**Triggers:**
- Pull request opened
- Pull request ready for review

**Key Features:**
- ✅ Enables GitHub's auto-merge feature
- ✅ Adds informative comment to PR
- ✅ Works for non-draft PRs

## 📖 GitHub Actions Basics

### Workflow Structure

GitHub Actions workflows are YAML files stored in `.github/workflows/` directory.

**Basic structure:**

```yaml
name: Workflow Name

on:
  # Triggers
  push:
    branches: [main]
  pull_request:
    branches: [main]

permissions:
  # Permissions needed
  contents: read
  pull-requests: write

jobs:
  job-name:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Run tests
        run: echo "Running tests..."
```

### Key Components

#### 1. Triggers (`on`)

Defines when the workflow runs:
- `push` - On code push
- `pull_request` - On PR events
- `schedule` - On a schedule (cron)
- `workflow_dispatch` - Manual trigger
- `release` - On release creation

#### 2. Permissions

Defines what the workflow can do:
- `contents: read` - Read repository contents
- `contents: write` - Modify repository contents
- `pull-requests: write` - Modify pull requests
- `checks: read` - Read check runs

#### 3. Jobs

Define the work to be done:
- Run on specified OS (ubuntu-latest, windows-latest, macos-latest)
- Execute in parallel or sequence
- Can depend on other jobs

#### 4. Steps

Individual tasks within a job:
- Use pre-built actions (`uses`)
- Run shell commands (`run`)
- Set environment variables
- Upload/download artifacts

### Common Actions

#### Checkout Code
```yaml
- name: Checkout repository
  uses: actions/checkout@v4
```

#### Setup Node.js
```yaml
- name: Setup Node.js
  uses: actions/setup-node@v4
  with:
    node-version: '20'
```

#### Setup Python
```yaml
- name: Setup Python
  uses: actions/setup-python@v5
  with:
    python-version: '3.11'
```

#### Setup PowerShell
```yaml
- name: Run PowerShell script
  shell: pwsh
  run: |
    Write-Host "Running PowerShell script"
    .\your-script.ps1
```

#### Cache Dependencies
```yaml
- name: Cache dependencies
  uses: actions/cache@v4
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
```

## 🛠️ Creating Your First Workflow

### Example: PowerShell Script Validation

Create `.github/workflows/powershell-validation.yml`:

```yaml
name: PowerShell Validation

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
    paths:
      - '**.ps1'

jobs:
  validate:
    runs-on: windows-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Run PSScriptAnalyzer
        shell: pwsh
        run: |
          Install-Module -Name PSScriptAnalyzer -Force -Scope CurrentUser
          $results = Invoke-ScriptAnalyzer -Path . -Recurse -Settings PSGallery
          if ($results) {
            $results | Format-Table
            exit 1
          }
```

### Example: Documentation Deployment

Create `.github/workflows/docs-deploy.yml`:

```yaml
name: Deploy Documentation

on:
  push:
    branches: [main]
    paths:
      - '**.md'
      - 'docs/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs
```

## 🔐 Security Best Practices

### 1. Use Secrets for Sensitive Data

Never hardcode credentials in workflows. Use GitHub Secrets:

```yaml
- name: Deploy
  env:
    API_TOKEN: ${{ secrets.API_TOKEN }}
  run: ./deploy.sh
```

### 2. Limit Permissions

Use least privilege principle:

```yaml
permissions:
  contents: read  # Only read, not write
```

### 3. Pin Action Versions

Use specific versions, not latest:

```yaml
- uses: actions/checkout@v4  # Good - specific version
- uses: actions/checkout@main  # Bad - unpredictable
```

### 4. Review Third-Party Actions

Only use actions from trusted sources:
- Official GitHub actions
- Verified creators
- Popular community actions with many stars

### 5. Use Environments for Sensitive Deployments

```yaml
jobs:
  deploy:
    environment: production
    runs-on: ubuntu-latest
```

## 📊 Monitoring and Debugging

### View Workflow Runs

1. Go to repository on GitHub
2. Click "Actions" tab
3. Select workflow from left sidebar
4. Click on specific run to see details

### Debugging Failed Workflows

**Enable debug logging:**
1. Go to repository settings
2. Secrets and variables → Actions
3. Add secret: `ACTIONS_STEP_DEBUG` with value `true`

**Add debug output in workflow:**
```yaml
- name: Debug information
  run: |
    echo "Runner OS: ${{ runner.os }}"
    echo "Branch: ${{ github.ref }}"
    echo "Event: ${{ github.event_name }}"
```

### Common Issues

#### Issue: Permission Denied
**Solution:** Check permissions in workflow file and repository settings.

#### Issue: Workflow Not Triggering
**Solution:** Verify trigger conditions and file paths.

#### Issue: Action Failed
**Solution:** Check action version, inputs, and logs.

## 🎯 Best Practices

### 1. Keep Workflows Fast
- Cache dependencies
- Run jobs in parallel
- Use appropriate runners
- Skip unnecessary steps

### 2. Make Workflows Reliable
- Handle failures gracefully
- Use timeouts
- Retry flaky tests
- Clean up resources

### 3. Make Workflows Maintainable
- Use descriptive names
- Add comments for complex logic
- Break into reusable workflows
- Document custom actions

### 4. Test Workflows Locally
Use tools like:
- **act** - Run GitHub Actions locally
- **nektos/act** - Docker-based local testing

### 5. Use Matrix Builds
Test across multiple versions:

```yaml
jobs:
  test:
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        node: [18, 20]
    runs-on: ${{ matrix.os }}
    
    steps:
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}
```

## 📚 Additional Resources

### Official Documentation
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)

### Tutorials
- [GitHub Actions Quickstart](https://docs.github.com/en/actions/quickstart)
- [Building and Testing PowerShell](https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-powershell)

### Community Resources
- [Awesome Actions](https://github.com/sdras/awesome-actions) - Curated list of actions
- [GitHub Actions Community Forum](https://github.community/c/actions)

## 🔄 Next Steps

1. Review existing workflows in `.github/workflows/`
2. Create custom workflows for your needs
3. Test workflows on feature branches
4. Monitor workflow runs regularly
5. Optimize based on feedback and metrics
6. Keep workflows updated with latest action versions

## 📝 Workflow Templates for This Repository

### PowerShell Script Testing
Create `.github/workflows/test-powershell.yml` for testing PowerShell scripts.

### Documentation Validation
Create `.github/workflows/validate-docs.yml` for checking markdown files.

### Security Scanning
Create `.github/workflows/security-scan.yml` for security analysis.

### Dependency Updates
Create `.github/workflows/update-dependencies.yml` for automated dependency updates.

---

## Summary

CI/CD is essential for modern software development, providing:
- **Automation** - Reduces manual work
- **Quality** - Catches bugs early
- **Speed** - Faster releases
- **Reliability** - Consistent processes
- **Confidence** - Safe deployments

This repository already has basic auto-merge workflows. You can extend these with additional workflows for testing, deployment, security scanning, and more.

For questions or issues, refer to the [GitHub Actions documentation](https://docs.github.com/en/actions) or open an issue in this repository.
