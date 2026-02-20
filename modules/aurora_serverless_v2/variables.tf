variable "name_prefix" { type = string }

variable "vpc_id"              { type = string }
variable "db_subnet_ids"       { type = list(string) }
variable "app_security_group_id" {
  type        = string
  description = "Security group ID of the application (ECS task SG). Allow inbound MySQL from this SG."
}

variable "db_name" {
  type    = string
  default = "wordpress"
}

variable "master_username" {
  type    = string
  default = "admin"
}

variable "master_password" {
  type        = string
  sensitive   = true
  description = "Master password for Aurora (use tfvars; later move to Secrets Manager)."
}

variable "engine_version" {
  type        = string
  description = "Aurora MySQL engine version (optional). If empty, use AWS default."
  default     = ""
}

variable "serverless_min_acu" {
  type    = number
  default = 0.5
}

variable "serverless_max_acu" {
  type    = number
  default = 2
}

variable "tags" {
  type    = map(string)
  default = {}
}