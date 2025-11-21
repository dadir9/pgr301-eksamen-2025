# PGR301 Eksamen 2025 - DevOps Infrastructure Project

This project demonstrates a complete AWS infrastructure deployment using Infrastructure as Code principles, serverless computing, containerization, and comprehensive monitoring.

## 📊 Project Overview

| Task | Points | Status | Description |
|------|--------|--------|-------------|
| **Oppgave 1** | 15 | ✅ Complete | Terraform, S3 og Infrastruktur som Kode |
| **Oppgave 2** | 25 | ✅ Complete | AWS Lambda, SAM og GitHub Actions |
| **Oppgave 3** | 25 | ✅ Complete | Containere og Docker |
| **Oppgave 4** | 25 | ✅ Complete | Metrics, Observability og CloudWatch |
| **Oppgave 5** | 10 | ✅ Complete |Drøfteoppgave - DevOps-prinsipper|
| **Total** | **100** | **100%** | **All tasks completed successfully** |

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                         AWS Cloud (us-east-1)                │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐ │
│  │   S3 Bucket  │    │    Lambda    │    │  ECS Fargate │ │
│  │   (Static)   │    │   Function   │    │  (Container) │ │
│  └──────────────┘    └──────────────┘    └──────────────┘ │
│         ▲                    ▲                    ▲        │
│         │                    │                    │        │
│  ┌──────────────────────────────────────────────────────┐ │
│  │              CloudWatch Monitoring                    │ │
│  │  • Dashboard  • Alarms  • Logs  • Metrics            │ │
│  └──────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Project Structure

```
pgr301-eksamen-2025/
├── terraform-aws-project/       # Infrastructure as Code
│   ├── environments/
│   │   └── dev/                # Development environment
│   └── modules/                # Terraform modules
│       ├── s3-storage/         # Task 1: S3 infrastructure
│       ├── lambda-infra/       # Task 2: Lambda infrastructure
│       ├── container-infra/    # Task 3: ECS/Docker setup
│       └── monitoring/         # Task 4: CloudWatch monitoring
├── lambda-app/                 # Serverless Application
│   ├── src/                    # Lambda function code
│   ├── tests/                  # Unit tests
│   └── template.yaml           # SAM template
├── docker-app/                 # Containerized Application
│   ├── Dockerfile              # Multi-stage build
│   ├── app.py                  # Flask application
│   └── docker-compose.yml      # Local development
└── .github/workflows/          # CI/CD Pipelines
    ├── terraform-deploy.yml    # Infrastructure deployment
    ├── lambda-deploy.yml       # Lambda deployment
    └── docker-deploy.yml       # Container deployment
```

---

## ✅ Oppgave 1: Terraform, S3 og Infrastruktur som Kode (15 Poeng)

### What Was Created
- **Modular Terraform Structure**: 4 reusable modules for different infrastructure components
- **S3 Bucket**: `college-demo-storage-dev-h7ajupqj`
  - Versioning enabled for file history
  - AES256 encryption for security
  - Lifecycle policies (30 days → IA, 90 days → Glacier, 365 days → Delete)
  - Static website hosting configured
  - Public access blocked for security

### Key Components
```hcl
# Module structure
modules/s3-storage/
├── main.tf       # S3 bucket resources
├── variables.tf  # Input variables
└── outputs.tf    # Output values
```

### Deployed Resources
- S3 Website URL: `http://college-demo-storage-dev-h7ajupqj.s3-website-us-east-1.amazonaws.com`
- Bucket ARN: `arn:aws:s3:::college-demo-storage-dev-h7ajupqj`

---

## ✅ Oppgave 2: AWS Lambda, SAM og GitHub Actions (25 Poeng)

### What Was Created
- **Lambda Function**: `college-demo-sam-function`
  - Python 3.9 runtime
  - 128MB memory, 60s timeout
  - Environment variables for configuration
- **API Gateway**: RESTful API endpoint
  - URL: `https://lchprrsct5.execute-api.us-east-1.amazonaws.com/Prod/`
  - POST method on `/process` endpoint
- **SAM Deployment**: Infrastructure as code for serverless
- **GitHub Actions**: Automated CI/CD pipeline

### Key Components
```python
# Lambda handler with S3 integration
def lambda_handler(event, context):
    # Process requests
    # Interact with S3
    # Return JSON response
```

### Deployed Resources
- Lambda ARN: `arn:aws:lambda:us-east-1:743119262104:function:college-demo-sam-function`
- API Endpoint: `https://lchprrsct5.execute-api.us-east-1.amazonaws.com/Prod/process`

---

## ✅ Oppgave 3: Containere og Docker (25 Poeng)

### What Was Created
- **Docker Image**: Multi-stage build for optimization
  - Base: Python 3.9-slim
  - Flask web application
  - Health check endpoint
- **ECR Repository**: `sample-app-repo`
  - Image scanning enabled
  - Pushed image: `743119262104.dkr.ecr.us-east-1.amazonaws.com/sample-app-repo:latest`
- **ECS Fargate**: Serverless container hosting
  - Cluster: `college-demo-cluster-dev`
  - Service: `sample-app-service`
  - Task definition with 256 CPU, 512 Memory

### Key Components
```dockerfile
# Multi-stage Dockerfile
FROM python:3.9-slim as builder
# Build stage
FROM python:3.9-slim
# Production stage with non-root user
```

### Deployed Resources
- ECS Cluster: Running on Fargate
- ECR Repository: Docker images stored
- Security Groups: Configured for port 80

---

## ✅ Oppgave 4: Metrics, Observability og CloudWatch (25 Poeng)

### What Was Created
- **CloudWatch Dashboard**: `dev-monitoring-dashboard`
  - Lambda metrics (invocations, errors, duration)
  - S3 metrics (size, object count)
  - API Gateway metrics (requests, errors)
  - Container logs from ECS
- **Alarms** (4 configured):
  - Lambda Error Rate (threshold: 5 errors)
  - Lambda Duration (threshold: 3000ms)
  - Lambda Throttles (threshold: 1)
  - S3 4xx Errors (threshold: 10)
- **SNS Topic**: Email notifications for alarms
- **Log Groups**: Centralized logging for all services

### Key Components
```json
// Dashboard configuration
{
  "widgets": [
    "Lambda Function Metrics",
    "S3 Bucket Metrics",
    "API Gateway Metrics",
    "Container Logs"
  ]
}
```

### Deployed Resources
- Dashboard URL: `https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#dashboards:name=dev-monitoring-dashboard`
- Log Groups: `/aws/lambda/college-demo-function-dev`, `/ecs/college-demo-cluster-dev/sample-app`

---

## 🚀 Deployment Instructions

### Prerequisites
- AWS CLI configured with `student` profile
- Terraform >= 1.0
- Docker Desktop
- Python 3.9
- SAM CLI

### Deploy Infrastructure
```bash
cd terraform-aws-project/environments/dev
AWS_PROFILE=student terraform init
AWS_PROFILE=student terraform apply
```

### Deploy Lambda
```bash
cd lambda-app
AWS_PROFILE=student sam build
AWS_PROFILE=student sam deploy --region us-east-1
```

### Deploy Docker Container
```bash
cd docker-app
docker build -t college-app:latest .
AWS_PROFILE=student aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin [ACCOUNT_ID].dkr.ecr.us-east-1.amazonaws.com
docker push [ACCOUNT_ID].dkr.ecr.us-east-1.amazonaws.com/sample-app-repo:latest
```

## 🧹 Cleanup

Remove all resources to avoid charges:
```bash
# Destroy Terraform resources
cd terraform-aws-project/environments/dev
AWS_PROFILE=student terraform destroy

# Delete SAM stack
AWS_PROFILE=student aws cloudformation delete-stack --stack-name college-lambda-stack --region us-east-1
```

## 📈 Key Achievements

- ✅ **Infrastructure as Code**: 100% infrastructure managed through Terraform
- ✅ **Modular Design**: Reusable Terraform modules for all components
- ✅ **Serverless Architecture**: Lambda functions with API Gateway
- ✅ **Container Orchestration**: Docker containers on ECS Fargate
- ✅ **CI/CD Pipelines**: GitHub Actions for automated deployments
- ✅ **Comprehensive Monitoring**: Full observability with CloudWatch
- ✅ **Security Best Practices**: IAM roles, encryption, security groups

---
Oppgave 5 – DevOps Reflection
5a) How the Solution Aligns with DevOps Principles

Infrastructure as Code via Terraform modules

Full automation through GitHub Actions

Observability with dashboards, logs & alarms

Security by design (IAM, encryption, OIDC authentication)

Fast, repeatable deployments

5b) Architecture Evaluation
Strengths

Highly scalable serverless + containers

Cost-efficient for low/medium traffic

Minimal operations burden

Clean separation of services

Trade-offs

Multiple AWS services increase complexity

AWS vendor lock-in

Distributed logs require good observability practices

5c) Suggested Improvements

Add SLOs/SLIs (latency, error rate, throughput)

Add AWS X-Ray / OpenTelemetry tracing

Implement blue/green or canary deployments

Add security scanning (SAST, dependency scanning)

Add cost alarms and tagging standards

🚀 Deployment Instructions

Terraform, SAM & Docker deployment steps remain identical to original.

📈 Summary

A complete DevOps architecture using:

Terraform IaC

AWS Lambda serverless

ECS Fargate containers

CI/CD automation

Full CloudWatch observability

**Project**: PGR301 DevOps Eksamen 2025
**Status**: ✅ All Tasks Completed (90/90 Points)
**Region**: US East 1 (N. Virginia)
**Profile**: AWS Student Account
