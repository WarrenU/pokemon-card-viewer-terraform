# Pokemon Card Viewer - AWS Deployment

This Terraform configuration deploys the Pokemon Card Viewer React app to AWS S3 as a static website.

## Prerequisites

1. AWS CLI configured with appropriate credentials
2. Terraform installed
3. The React app built (`npm run build` in the main project)

## Usage

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Plan the deployment:**
   ```bash
   terraform plan
   ```

3. **Deploy the infrastructure:**
   ```bash
   terraform apply
   ```

4. **Build and upload the React app:**
   ```bash
   # From the main project directory
   npm run build
   
   # Upload to S3 (replace BUCKET_NAME with the output from terraform)
   aws s3 sync build/ s3://BUCKET_NAME --delete
   ```

5. **Access your website:**
   The website URL will be displayed after `terraform apply`

## Cost

- S3 storage: ~$0.023 per GB per month
- S3 requests: ~$0.0004 per 1,000 GET requests
- For a typical React app, this costs less than $1/month

## Cleanup

To destroy the infrastructure:
```bash
terraform destroy
```
