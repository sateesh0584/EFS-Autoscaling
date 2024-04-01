module "vpc" {
  source = "./modules/aws-vpc"

  vpc-name        = var.VPC-NAME
  vpc-cidr        = var.VPC-CIDR
  igw-name        = var.IGW-NAME
  public-cidr1    = var.PUBLIC-CIDR1
  public-subnet1  = var.PUBLIC-SUBNET1
  public-cidr2    = var.PUBLIC-CIDR2
  public-subnet2  = var.PUBLIC-SUBNET2
  public-rt-name1  = var.PUBLIC-RT-NAME1
  public-rt-name2  = var.PUBLIC-RT-NAME2
 
}

module "security-group" {
  source     = "./modules/security-group"
  vpc-name   = var.VPC-NAME
  vpc_id     = module.vpc.vpc_id  
  alb-sg-name = var.ALB-SG-NAME
  Asg-sg-name = var.Asg-SG-NAME
  depends_on = [module.vpc]
}
module "ec2" {
  source                 = "./modules/ec2"
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.subnet_ids 
  file_system_dns_name   = module.efs.file_system_dns_name 
  key_name               = var.key_name
  vpc_security_group_ids = module.security-group.alb-sg
  alb-sg-name            = var.ALB-SG-NAME
  public-subnet-name1    = var.PUBLIC-SUBNET1
  public-subnet-name2    = var.PUBLIC-SUBNET2
  depends_on             = [module.efs]
}


module "efs" {
  source = "./modules/efs"
  subnet_id = module.vpc.subnet_ids
  efs_security_group_ids = module.security-group.alb-sg 
  depends_on = [module.vpc]
}

module "alb" {
  source = "./modules/alb-tg"

  public-subnet-name1 = var.PUBLIC-SUBNET1
  public-subnet-name2 = var.PUBLIC-SUBNET2
  web-alb-sg-name     = var.ALB-SG-NAME
  alb-name            = var.ALB-NAME
  tg-name             = var.TG-NAME
  vpc-name            = var.VPC-NAME
  depends_on = [module.ec2]

}


module "autoscaling" {
  source                = "./modules/aws-autoscaling"
  ec2ami_id             = module.ec2.ec2ami_id  
  key_name               = var.key_name
  launch-template-name  = var.LAUNCH-TEMPLATE-NAME
  instance-profile-name = var.INSTANCE-PROFILE-NAME
  subnet_id              = module.vpc.subnet_ids
  vpc_security_group_ids = module.security-group.alb-sg
  web-sg-name           = var.ALB-SG-NAME
  tg-name               = var.TG-NAME
  public-subnet-name1   = var.PUBLIC-SUBNET1
  public-subnet-name2   = var.PUBLIC-SUBNET2
  asg-name              = var.ASG-NAME
  depends_on            = [module.ec2]
}











