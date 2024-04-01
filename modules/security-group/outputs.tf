output "alb-sg" {
  value = [aws_security_group.alb-sg.id]
}
output "Asg-sg" {
  value = [aws_security_group.Asg-sg.id]
}