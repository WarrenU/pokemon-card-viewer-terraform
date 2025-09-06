#!/bin/bash

# Build the React app
echo "Building React app..."
cd ../pokemon-card-viewer

npm run build

if [ $? -ne 0 ]; then
    echo "Build failed!"
    exit 1
fi

# Get back to terraform directory
cd ../pokemon-card-viewer-terraform

# Apply Terraform if not already applied
echo "Checking if infrastructure exists..."
if ! terraform show >/dev/null 2>&1; then
    echo "Deploying infrastructure..."
    terraform init
    terraform apply -auto-approve
fi

# Get bucket name from Terraform output
BUCKET_NAME=$(terraform output -raw bucket_name)

if [ -z "$BUCKET_NAME" ]; then
    echo "Failed to get bucket name from Terraform output"
    exit 1
fi

# Upload the built app to S3
echo "Uploading to S3 bucket: $BUCKET_NAME"
aws s3 sync ../pokemon-card-viewer/build/ s3://$BUCKET_NAME --delete

if [ $? -eq 0 ]; then
    echo "Deployment successful!"
    echo "Website URL: $(terraform output -raw website_url)"
else
    echo "Upload failed!"
    exit 1
fi
