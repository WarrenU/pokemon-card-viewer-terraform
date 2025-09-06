# AWS Secrets Manager configuration for Pokemon Card Viewer
# This file manages API keys and other sensitive configuration

# Random password for the secret (optional, for additional security)
resource "random_password" "pokemon_api_secret" {
  length  = 32
  special = true
}

# AWS Secrets Manager secret for Pokemon API configuration
resource "aws_secretsmanager_secret" "pokemon_api_keys" {
  name                    = "pokemon-card-viewer/api-keys"
  description             = "API keys and configuration for Pokemon Card Viewer application"
  recovery_window_in_days = 7

  tags = {
    Name        = "pokemon-card-viewer-api-keys"
    Environment = var.environment
    Project     = "pokemon-card-viewer"
    ManagedBy   = "terraform"
  }
}

# Secret version with the actual API keys
resource "aws_secretsmanager_secret_version" "pokemon_api_keys" {
  secret_id = aws_secretsmanager_secret.pokemon_api_keys.id
  secret_string = jsonencode({
    pokemon_api_key        = var.pokemon_api_key
    pokemon_api_base_url   = "https://api.pokemontcg.io/v2"
    environment           = var.environment
    created_by           = "terraform"
    created_at           = timestamp()
  })

  lifecycle {
    ignore_changes = [
      secret_string
    ]
  }
}

# IAM policy for reading the secret
resource "aws_iam_policy" "pokemon_secrets_read" {
  name        = "pokemon-card-viewer-secrets-read-${var.environment}"
  description = "Policy to read Pokemon API secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.pokemon_api_keys.arn
      }
    ]
  })

  tags = {
    Name        = "pokemon-card-viewer-secrets-read"
    Environment = var.environment
    Project     = "pokemon-card-viewer"
  }
}

# IAM role for the application to read secrets
resource "aws_iam_role" "pokemon_app_role" {
  name = "pokemon-card-viewer-app-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com",
            "ecs-tasks.amazonaws.com",
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
  })

  tags = {
    Name        = "pokemon-card-viewer-app-role"
    Environment = var.environment
    Project     = "pokemon-card-viewer"
  }
}

# Attach the secrets read policy to the role
resource "aws_iam_role_policy_attachment" "pokemon_secrets_read" {
  role       = aws_iam_role.pokemon_app_role.name
  policy_arn = aws_iam_policy.pokemon_secrets_read.arn
}

# Attach basic execution policy for Lambda/ECS
resource "aws_iam_role_policy_attachment" "pokemon_basic_execution" {
  role       = aws_iam_role.pokemon_app_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Output the secret ARN for reference
output "pokemon_secrets_arn" {
  description = "ARN of the Pokemon API secrets"
  value       = aws_secretsmanager_secret.pokemon_api_keys.arn
}

output "pokemon_app_role_arn" {
  description = "ARN of the application IAM role"
  value       = aws_iam_role.pokemon_app_role.arn
}
