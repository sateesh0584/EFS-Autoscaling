output "ec2ami_id" {
  value = aws_ami_from_instance.example_ami.id

}
output "public_ip" {
  value = aws_instance.example.public_ip
}
