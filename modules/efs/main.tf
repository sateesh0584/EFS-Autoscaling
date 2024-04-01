resource "aws_efs_file_system" "example" {
  creation_token     = var.efs_creation_token
  performance_mode   = var.efs_performance_mode
  throughput_mode    = var.efs_throughput_mode
  encrypted          = true
}

resource "aws_efs_mount_target" "example" {
  file_system_id       = aws_efs_file_system.example.id
  subnet_id            = var.subnet_id
  security_groups      = var.efs_security_group_ids
}
