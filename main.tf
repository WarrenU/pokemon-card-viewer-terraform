# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"  # Change to your preferred region
}

# S3 bucket for hosting the static website
resource "aws_s3_bucket" "pokemon_card_viewer" {
  bucket = "pokemon-card-viewer-${random_string.bucket_suffix.result}"
}

# Random string for unique bucket name
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 bucket versioning
resource "aws_s3_bucket_versioning" "pokemon_card_viewer" {
  bucket = aws_s3_bucket.pokemon_card_viewer.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket public access block
resource "aws_s3_bucket_public_access_block" "pokemon_card_viewer" {
  bucket = aws_s3_bucket.pokemon_card_viewer.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 bucket policy to allow public read access
resource "aws_s3_bucket_policy" "pokemon_card_viewer" {
  bucket = aws_s3_bucket.pokemon_card_viewer.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.pokemon_card_viewer.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.pokemon_card_viewer]
}

# S3 bucket website configuration
resource "aws_s3_bucket_website_configuration" "pokemon_card_viewer" {
  bucket = aws_s3_bucket.pokemon_card_viewer.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"  # For React Router to handle client-side routing
  }
}

# Output the website URL
output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.pokemon_card_viewer.website_endpoint}"
}

output "bucket_name" {
  value = aws_s3_bucket.pokemon_card_viewer.bucket
}
