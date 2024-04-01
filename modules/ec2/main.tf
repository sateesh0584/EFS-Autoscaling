resource "aws_instance" "example" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  source_dest_check           = false
  associate_public_ip_address = true
  vpc_security_group_ids      = var.vpc_security_group_ids
  user_data                   = file("${path.module}/userdata.sh")

  provisioner "remote-exec" {
    inline = [
      "#!/bin/bash",
      "set -e",
      #"sudo su -",
      "sudo apt-get update",
      "sudo apt-get install -y binutils docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo curl -L 'https://github.com/docker/compose/releases/latest/download/docker-compose-Linux-x86_64' -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "docker-compose --version",
      "sudo apt-get install -y binutils",
      "sudo apt-get -y update",
      "git clone https://github.com/aws/efs-utils",
      "cd efs-utils",
      "./build-deb.sh",
      "sudo apt-get -y install ./build/amazon-efs-utils*deb",
      "sudo apt-get -y update",
      "echo 'EFS_UTILS_YUM_CONF_PATH=/etc/yum.conf' | sudo tee -a /etc/amazon/efs/efs-utils.conf",
      
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/Key.pem")  
    host        = self.public_ip
  }

  tags = {
    Name = "Example"
  }
}
resource "null_resource" "connection" {
 # depends_on = [module.efs]
   connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/Key.pem")
    host        = aws_instance.example.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      
      "# Create Docker Compose YAML file",
      "cat <<EOF > docker.yaml",
      "version: '3'",
      "services:",
      "  nginx:",
      "    image: nginx:latest",
      "    ports:",
      "      - '80:80'",
      "    restart: always",
      "EOF",
      "sudo docker-compose -f docker.yaml up -d",
      "sudo touch /etc/rc.local",
      "echo 'sudo docker start  ubuntu-nginx-1' | sudo tee -a /etc/rc.local",
      "sudo chmod +x /etc/rc.local",
      # Create a mount point for EFS
      "sudo mkdir -p /root/efs",
      
      # Mount the EFS volume
      "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${var.file_system_dns_name}.efs.ap-south-1.amazonaws.com:/ /root/efs",
      
      # Create fstab entry to ensure automount on reboots
      "echo '${var.file_system_dns_name}.efs.ap-south-1.amazonaws.com:/ /root/efs nfs4 defaults,vers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport 0 0' | sudo tee -a /etc/fstab",
    ]
  }
}

# Create an AMI from the EC2 instance
resource "aws_ami_from_instance" "example_ami" {
  name               = "example-ami"
  source_instance_id = aws_instance.example.id
  depends_on = [null_resource.connection]
}
