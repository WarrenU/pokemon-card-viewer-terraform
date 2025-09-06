# Outputs for Pokemon Card Viewer Terraform configuration

output "secrets_arn" {
  description = "ARN of the Pokemon API secrets"
  value       = aws_secretsmanager_secret.pokemon_api_keys.arn
}

output "secrets_name" {
  description = "Name of the Pokemon API secrets"
  value       = aws_secretsmanager_secret.pokemon_api_keys.name
}

output "app_role_arn" {
  description = "ARN of the application IAM role"
  value       = aws_iam_role.pokemon_app_role.arn
}

output "app_role_name" {
  description = "Name of the application IAM role"
  value       = aws_iam_role.pokemon_app_role.name
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "region" {
  description = "AWS region"
  value       = var.region
}

# Output for use in other Terraform configurations
output "pokemon_secrets_config" {
  description = "Configuration for Pokemon secrets"
  value = {
    secret_arn    = aws_secretsmanager_secret.pokemon_api_keys.arn
    secret_name   = aws_secretsmanager_secret.pokemon_api_keys.name
    role_arn      = aws_iam_role.pokemon_app_role.arn
    role_name     = aws_iam_role.pokemon_app_role.name
    environment   = var.environment
    region        = var.region
  }
}

# Environment variables for React app
output "react_app_env_vars" {
  description = "Environment variables for React app deployment"
  value = {
    REACT_APP_AWS_REGION                        = var.region
    REACT_APP_AWS_SECRETS_MANAGER_SECRET_NAME   = aws_secretsmanager_secret.pokemon_api_keys.name
    REACT_APP_POKEMON_API_BASE_URL              = "https://api.pokemontcg.io/v2"
    NODE_ENV                                     = var.environment == "prod" ? "production" : "development"
  }
}

# JSON format for easy consumption
output "react_app_env_vars_json" {
  description = "Environment variables in JSON format"
  value = jsonencode({
    REACT_APP_AWS_REGION                        = var.region
    REACT_APP_AWS_SECRETS_MANAGER_SECRET_NAME   = aws_secretsmanager_secret.pokemon_api_keys.name
    REACT_APP_POKEMON_API_BASE_URL              = "https://api.pokemontcg.io/v2"
    NODE_ENV                                     = var.environment == "prod" ? "production" : "development"
  })
}
