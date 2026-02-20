variable "project" {
  type        = string
  description = "Project name (e.g., aws-serverless-wordpress)"
}

variable "env" {
  type        = string
  description = "Environment name (e.g., dev)"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "10.20.0.0/16"
}

variable "az_count" {
  type        = number
  description = "Number of AZs to use"
  default     = 2
}

variable "db_master_password" {
  type        = string
  sensitive   = true
  description = "Aurora master password (dev only)."
}
