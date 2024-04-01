# EFS

variable "efs_creation_token" {
  type        = string
  description = "A unique string used to ensure idempotent creation of the EFS file system."
  default     = "efs-example"
}

variable "efs_performance_mode" {
  type        = string
  description = "The performance mode of the file system."
  default     = "generalPurpose"
}

variable "efs_throughput_mode" {
  type        = string
  description = "The throughput mode for the file system."
  default     = "bursting"
}
variable "subnet_id" {}
#variable "vpc_id" {}
variable "efs_security_group_ids" {}



