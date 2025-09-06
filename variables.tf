# Variables for Pokemon Card Viewer Terraform configuration

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "pokemon_api_key" {
  description = "Pokemon TCG API key"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.pokemon_api_key) > 0
    error_message = "Pokemon API key cannot be empty."
  }
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "pokemon-card-viewer"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "pokemon-card-viewer"
    ManagedBy   = "terraform"
    Environment = "dev"
  }
}

# Optional: Additional API keys for other services
variable "additional_api_keys" {
  description = "Additional API keys for other services"
  type        = map(string)
  default     = {}
  sensitive   = true
}

# Optional: KMS key for additional encryption
variable "kms_key_id" {
  description = "KMS key ID for additional encryption (optional)"
  type        = string
  default     = null
}

# Optional: Secret rotation configuration
variable "enable_secret_rotation" {
  description = "Enable automatic secret rotation"
  type        = bool
  default     = false
}

variable "rotation_lambda_arn" {
  description = "ARN of the Lambda function for secret rotation"
  type        = string
  default     = null
}
