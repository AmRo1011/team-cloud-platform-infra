variable "env" {
  description = "Environment name (dev/staging/prod)"
  type        = string
  default     = "dev"
}

variable "db_subnet_ids" {
  description = "List of subnet IDs for RDS"
  type        = list(string)
}

variable "vpc_id" {
  type = string
}

variable "app_sg_ids" {
  type = list(string)
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
  sensitive = true
}
