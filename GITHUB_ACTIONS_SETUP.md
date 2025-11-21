# 🔧 GitHub Actions Setup Guide

This guide explains how to use GitHub Actions for automated CI/CD deployment.

## 📋 Configured Workflows

### 1. **terraform-deploy.yml**
- **Trigger**: Push to `main` branch when Terraform files change
- **Purpose**: Deploy infrastructure with Terraform
- **Path**: `.github/workflows/terraform-deploy.yml`

### 2. **lambda-deploy.yml**
- **Trigger**: Push to `main` branch when Lambda files change
- **Purpose**: Deploy Lambda functions with SAM
- **Path**: `.github/workflows/lambda-deploy.yml`

### 3. **docker-deploy.yml**
- **Trigger**: Push to `main` branch when Docker files change
- **Purpose**: Build and push Docker images to ECR
- **Path**: `.github/workflows/docker-deploy.yml`

## 🔐 AWS Credentials Configuration

### Current Setup (Hardcoded for Testing)
The workflows currently have AWS credentials **hardcoded** for quick testing:
```yaml
aws-access-key-id: AKIA22BK4CGMHBPBVZ4X
aws-secret-access-key: 8xdvrsYCMT9CzaelkliiPZsU1VR8Mn5JdLk1zwv6k
```

### ⚠️ Important Security Note
**For production/real projects**, NEVER hardcode credentials! Use GitHub Secrets instead.

## 🚀 How to Use

### Step 1: Push to GitHub
```bash
# Initialize git repository
git init
git add .
git commit -m "Initial commit"

# Add GitHub remote
git remote add origin https://github.com/YOUR_USERNAME/pgr301-eksamen-2025.git

# Push to GitHub
git push -u origin main
```

### Step 2: Workflows Will Auto-Run
When you push changes:
- **Terraform files changed** → terraform-deploy.yml runs
- **Lambda files changed** → lambda-deploy.yml runs
- **Docker files changed** → docker-deploy.yml runs

### Step 3: Monitor in GitHub
1. Go to your repository on GitHub
2. Click on **Actions** tab
3. Watch the workflows run
4. Green checkmark = Success ✅

## 🔄 How to Switch to Secure Method (GitHub Secrets)

### Step 1: Add Secrets to GitHub
1. Go to repository **Settings**
2. Click **Secrets and variables** → **Actions**
3. Add these secrets:
   - `AWS_ACCESS_KEY_ID`: Your AWS access key
   - `AWS_SECRET_ACCESS_KEY`: Your AWS secret key

### Step 2: Update Workflows
In each workflow file, comment the hardcoded lines and uncomment the secrets lines:

```yaml
# Comment these lines
# aws-access-key-id: AKIA22BK4CGMHBPBVZ4X
# aws-secret-access-key: 8xdvrsYCMT9CzaelkliiPZsU1VR8Mn5JdLk1zwv6k

# Uncomment these lines
aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

## 📊 Workflow Status Badges

Add these to your README to show build status:

```markdown
![Terraform](https://github.com/YOUR_USERNAME/pgr301-eksamen-2025/actions/workflows/terraform-deploy.yml/badge.svg)
![Lambda](https://github.com/YOUR_USERNAME/pgr301-eksamen-2025/actions/workflows/lambda-deploy.yml/badge.svg)
![Docker](https://github.com/YOUR_USERNAME/pgr301-eksamen-2025/actions/workflows/docker-deploy.yml/badge.svg)
```

## 🛠️ Troubleshooting

### Common Issues

1. **Workflow not triggering**
   - Check if you're pushing to `main` branch
   - Check if you've changed files in the watched paths

2. **AWS credentials error**
   - Verify credentials are correct
   - Check AWS region is `us-east-1`

3. **Terraform state issues**
   - Consider using S3 backend for state storage
   - Run `terraform init` locally first

4. **Docker push fails**
   - ECR repository must exist (created by Terraform)
   - Check ECR permissions

## 📝 Notes for College Assignment

- **Current Setup**: Hardcoded credentials for simplicity
- **Region**: All resources deploy to `us-east-1`
- **Profile**: Using student AWS account
- **Auto-deploy**: Enabled on push to main branch

---

**Created for PGR301 Eksamen 2025**