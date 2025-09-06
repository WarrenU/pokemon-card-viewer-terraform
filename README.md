# Pokemon Card Viewer - Terraform Infrastructure

This directory contains the Terraform configuration for the Pokemon Card Viewer application infrastructure.

## Overview

This Terraform configuration manages:
- AWS Secrets Manager for API keys
- IAM roles and policies for secure access
- Environment-specific configurations

## Prerequisites

1. **Terraform** (version 1.0+)
2. **AWS CLI** configured with appropriate credentials
3. **Pokemon TCG API key** (get from [Pokemon TCG API](https://pokemontcg.io/))

## Quick Start

1. **Clone and navigate to this directory:**
   ```bash
   cd pokemon-card-viewer-terraform
   ```

2. **Copy the example variables file:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. **Edit terraform.tfvars with your values:**
   ```hcl
   environment = "dev"
   region      = "us-east-1"
   pokemon_api_key = "your_actual_api_key_here"
   ```

4. **Initialize Terraform:**
   ```bash
   terraform init
   ```

5. **Plan the deployment:**
   ```bash
   terraform plan
   ```

6. **Apply the configuration:**
   ```bash
   terraform apply
   ```

## Environment Variables

Instead of using terraform.tfvars, you can use environment variables:

```bash
export TF_VAR_pokemon_api_key="your_api_key_here"
export TF_VAR_environment="dev"
export TF_VAR_region="us-east-1"
```

## Security Best Practices

### 1. **Never commit sensitive values:**
- Add `terraform.tfvars` to `.gitignore`
- Use environment variables for sensitive data
- Consider using AWS Parameter Store or external secret management

### 2. **Use different environments:**
```bash
# Development
terraform apply -var="environment=dev"

# Staging
terraform apply -var="environment=staging"

# Production
terraform apply -var="environment=prod"
```

### 3. **Rotate secrets regularly:**
- Update the secret in AWS Secrets Manager
- The application will automatically pick up new values

## Integration with React App

The React app is configured to automatically use these secrets:

1. **Environment Variables** (for local development):
   ```bash
   REACT_APP_AWS_REGION=us-east-1
   REACT_APP_AWS_SECRETS_MANAGER_SECRET_NAME=pokemon-card-viewer/api-keys
   ```

2. **AWS IAM Role** (for deployed environments):
   - The app will automatically assume the IAM role
   - No additional configuration needed

## Outputs

After applying, you'll get these outputs:
- `secrets_arn`: ARN of the secrets
- `app_role_arn`: ARN of the IAM role
- `environment`: Environment name
- `region`: AWS region

## Troubleshooting

### Common Issues:

1. **"Access Denied" errors:**
   - Check IAM permissions
   - Ensure the role has `secretsmanager:GetSecretValue` permission

2. **"Secret not found" errors:**
   - Verify the secret name matches
   - Check the region is correct

3. **"Invalid credentials" errors:**
   - Check AWS CLI configuration
   - Verify the IAM role is properly attached

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

**Warning:** This will permanently delete all secrets and IAM resources.

## Next Steps

1. Deploy your React app with the IAM role
2. Configure your CI/CD pipeline to use these secrets
3. Set up monitoring and alerting for secret access
4. Consider implementing secret rotation