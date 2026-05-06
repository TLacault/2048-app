<!-- fullWidth: false tocVisible: false tableWrap: true -->
# Production Deployment Setup Guide

## Overview

This project has two deployment approaches configured:

### Approach 1: CI Job with Environment Protection (Auto-trigger)

- **File**: `.github/workflows/triggers.yaml`
- **Trigger**: Automatically runs after successful CI on main branch
- **Protection**: Requires manual approval via GitHub Environment
- **Use case**: Production deployments after code review and testing

### Approach 2: Manual Workflow Dispatch (Manual Trigger)

- **File**: `.github/workflows/deploy-production.yaml`
- **Trigger**: Manual trigger via `workflow_dispatch` or after CI success
- **Flexibility**: Can rebuild or use artifact from CI
- **Use case**: Testing deployments or deploying to production on-demand

## Required Configuration

### 1\. Set up GitHub Secrets

You need to configure the following secrets in your GitHub repository settings:

#### Required Secrets:

- `VERCEL_TOKEN`: Your Vercel API token
- `VERCEL_PROJECT_ID`: Your Vercel project ID
- `VERCEL_ORG_ID`: Your Vercel organization/team ID

#### Where to find these values:

**Option A: From .vercel/project.json (local)**

```json
{
  "projectId": "prj_...",
  "orgId": "team_...",
  "projectName": "tl-2048-app"
}
```

**Option B: Using Vercel CLI**

```bash
vercel whoami        # Get user/org ID
vercel projects list # Get project ID
```

**Option C: From .env (local)**

```env
VERCEL_TOKEN=...
VERCEL_PROJECT_ID=...
```

### 2\. Configure GitHub Environment (for Approach 1)

To enable environment protection in GitHub:

1. Go to your repository settings
2. Navigate to **Environments**
3. Create a new environment named `production`
4. (Optional) Configure required reviewers under "Deployment branches"
5. (Optional) Set deployment restrictions (e.g., main branch only)

This will require manual approval before the deployment job runs.

### 3\. Add Secrets to GitHub Repository

#### Steps to add secrets:

1. Go to Repository Settings → **Secrets and variables** → **Actions**
2. Create the following secrets:

```
VERCEL_TOKEN=vcp_...
VERCEL_PROJECT_ID=prj_...
VERCEL_ORG_ID=team_...
```

## Testing the Deployment

### Test 1: Using manual workflow dispatch (Approach 2)

```bash
# Push to main branch (or any branch)
git push origin feature-branch

# The workflow will appear in GitHub Actions
# Click "Run workflow" → "Deploy Production"
```

Or via GitHub CLI:

```bash
gh workflow run deploy-production.yaml --ref main
```

### Test 2: Using CI workflow with auto-trigger (Approach 1)

```bash
# Push to main branch
git push origin main

# Wait for CI workflow to complete successfully
# Then approve the production deployment:
# 1. Go to Actions tab
# 2. Click on the workflow run
# 3. Scroll to "Deployments" section
# 4. Click "Review deployments"
# 5. Approve the production deployment
```

### Test 3: Monitor deployment

1. Go to **Actions** tab in your repository
2. Click on the deployment workflow run
3. Check the logs in real-time
4. Look for "Deploy to Vercel Production" step

### Test 4: Verify production deployment

After successful deployment:

```bash
# Check if the app is accessible
curl https://tl-2048-app.vercel.app

# Or open in browser
open https://tl-2048-app.vercel.app
```

## Troubleshooting

### Issue: "Unknown error downloading artifact"

- **Cause**: Artifact retention period expired (default: 1 day)
- **Solution**: Use `workflow_dispatch` instead or rebuild locally in deploy-production workflow

### Issue: "VERCEL_TOKEN is invalid"

- **Cause**: Invalid or expired token in secrets
- **Solution**: Generate a new token from Vercel dashboard and update GitHub secrets

### Issue: "Project not found"

- **Cause**: VERCEL_PROJECT_ID or VERCEL_ORG_ID is incorrect
- **Solution**: Verify values match with `.vercel/project.json`

### Issue: "Deployment to Vercel failed"

- Check Vercel CLI logs in GitHub Actions output
- Verify project is configured correctly in Vercel dashboard
- Check that `.output/` directory was built correctly

## Environment URLs

- **Production**: https://tl-2048-app.vercel.app
- **Preview**: https://tl-2048-app-\*.vercel.app (auto-generated for PRs)

## git Commits

All changes follow Conventional Commits:

```bash
git commit -m "ci: add production deployment with environment protection"
```
