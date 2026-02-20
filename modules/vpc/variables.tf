variable "name_prefix" {
  type        = string
  description = "Prefix for resource names"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "az_count" {
  type        = number
  description = "Number of AZs"
  default     = 2
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}