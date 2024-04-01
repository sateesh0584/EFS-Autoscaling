# Creating VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = var.vpc-name
  }
}
# Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.igw-name
  }
  depends_on = [ aws_vpc.vpc ]
}
# Creating Public Subnet 1 for Web Tier Instance
resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public-cidr1
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = var.public-subnet1
  }
  depends_on = [ aws_internet_gateway.igw ]
}
# Creating Public Subnet 2 for Web Tier Instance
resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public-cidr2
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = var.public-subnet2
  }
  depends_on = [ aws_subnet.public-subnet1 ]
}
# Creating Public Route table 1
resource "aws_route_table" "public-rt1" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = var.public-rt-name1
  }
}
# Associating the Public Route table 1 Public Subnet 1
resource "aws_route_table_association" "public-rt-association1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public-rt1.id

  depends_on = [ aws_route_table.public-rt1 ]
}
# Creating Public Route table 2 
resource "aws_route_table" "public-rt2" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.public-rt-name2
  }
  
  depends_on = [ aws_route_table_association.public-rt-association1 ]
}

# Associating the Public Route table 2 Public Subnet 2
resource "aws_route_table_association" "public-rt-association2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.public-rt2.id

  depends_on = [ aws_route_table.public-rt1 ]
}

