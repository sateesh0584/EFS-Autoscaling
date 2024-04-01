# VPC
VPC-NAME         = "VPC"
VPC-CIDR         = "10.0.0.0/16"
IGW-NAME         = "Interet-Gateway"
PUBLIC-CIDR1     = "10.0.1.0/24"
PUBLIC-SUBNET1   = "Public-Subnet1"
PUBLIC-CIDR2     = "10.0.2.0/24"
PUBLIC-SUBNET2   = "Public-Subnet2"
PUBLIC-RT-NAME1  = "Public-Route-table1"
PUBLIC-RT-NAME2  = "Public-Route-table2"


# SECURITY GROUP
ALB-SG-NAME = "alb-sg"
Asg-SG-NAME = "web-sg"

# EC2
ami_id="ami-03bb6d83c60fc5f7c"
#ec2_count="1"
instance_type="t2.micro"
key_name="Key"
#alb-sg-name ="new"
 # ALB
TG-NAME  = "Web-TG"
ALB-NAME = "Web-elb"

# AUTOSCALING
LAUNCH-TEMPLATE-NAME = "Web-template"
ASG-NAME             = "ASG"
INSTANCE-PROFILE-NAME = "example-instance-profile-name"

#EFS
efs_creation_token ="efs-example"
efs_performance_mode ="generalPurpose"
efs_throughput_mode ="bursting"

