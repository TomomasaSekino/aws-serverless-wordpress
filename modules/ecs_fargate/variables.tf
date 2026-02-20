variable "name_prefix" { type = string }

variable "vpc_id"     { type = string }
variable "subnet_ids" { type = list(string) }

variable "alb_sg_id"         { type = string }
variable "target_group_arn"  { type = string }

variable "container_image" {
  type        = string
  description = "Container image (e.g., nginx:alpine or ECR URL)"
  default     = "nginx:alpine"
}

variable "container_port" {
  type    = number
  default = 80
}

variable "cpu" {
  type    = number
  default = 256
}

variable "memory" {
  type    = number
  default = 512
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "assign_public_ip" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "environment" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "Container environment variables"
}
