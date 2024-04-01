# VPC
variable "VPC-NAME" {}
variable "VPC-CIDR" {}
variable "IGW-NAME" {}
variable "PUBLIC-CIDR1" {}
variable "PUBLIC-SUBNET1" {}
variable "PUBLIC-CIDR2" {}
variable "PUBLIC-SUBNET2" {}
variable "PUBLIC-RT-NAME1" {}
variable "PUBLIC-RT-NAME2" {}

# SECURITY GROUP
variable "ALB-SG-NAME" {}
variable "Asg-SG-NAME" {}
#ec2
#variable "ec2_count" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}


#variable "alb-sg-name" {}
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
# ALB
variable "TG-NAME" {}
variable "ALB-NAME" {}

# AUTOSCALING
variable "LAUNCH-TEMPLATE-NAME" {}
variable "ASG-NAME" {}



variable "INSTANCE-PROFILE-NAME" {}

