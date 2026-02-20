variable "name_prefix" {
  type        = string
  description = "Prefix for resource names"
}

variable "repo_name" {
  type        = string
  description = "ECR repository name suffix (e.g., wordpress)"
}

variable "tags" {
  type        = map(string)
  default     = {}
}