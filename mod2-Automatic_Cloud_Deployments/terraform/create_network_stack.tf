#Define AWS as a provider (region defined in variables.tf)
provider "aws" {
  region = var.aws_region
}


#Create AWS VPC (CIDR Values defined in variables.tf)
resource "aws_vpc" "tf_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "tf_vpc"
  }
}

#Create AWS Internet Gateway and associate with previously created AWS VPC
resource "aws_internet_gateway" "InternetGW" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "TF_Internet_GW"
  }
}


#Create Public Subnet A and associate with previously created AWS VPC (CIDR_BLOCK defined in variables.tf)
resource "aws_subnet" "TF_PublicSubnetA" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.public_subnetA
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "TF_PublicSubnetA"
  }
}


#Create Public Subnet B and associate with previously created AWS VPC (CIDR_BLOCK defined in variables.tf)
resource "aws_subnet" "TF_PublicSubnetB" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.public_subnetB
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "TF_PublicSubnetB"
  }
}


#Create Private Subnet A and associate with previously created AWS VPC (CIDR_BLOCK defined in variables.tf)
resource "aws_subnet" "TF_PrivateSubnetA" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = var.private_subnetA
  availability_zone = "eu-west-1a"

  tags = {
    Name = "TF_PrivateSubnetA"
  }
}

#Create Private Subnet B and associate with previously created AWS VPC (CIDR_BLOCK defined in variables.tf)
resource "aws_subnet" "TF_PrivateSubnetB" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = var.private_subnetB
  availability_zone = "eu-west-1b"

  tags = {
    Name = "TF_PrivateSubnetA"
  }
}

#Create Routing Table with default route pointing to Internet Gateway
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.InternetGW.id
  }

  tags = {
    Name = "Public Routing Table"
  }

}

#Create Routing Table association with PublicSubnets
resource "aws_route_table_association" "publicA" {
  subnet_id      = aws_subnet.TF_PublicSubnetA.id
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "publicB" {
  subnet_id      = aws_subnet.TF_PublicSubnetB.id
  route_table_id = aws_route_table.PublicRT.id
}


#Create Security Group 
resource "aws_security_group" "PublicSG" {
  name        = "PublicSG"
  description = "Allow SSH Traffic In and HTTP(S) and ICMP Out"
  vpc_id      = aws_vpc.tf_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["8.8.8.8/32"]
  }

  tags = {
    Name = "WebServers Security Group"
  }
}

#Create 1st VM in PublicSubnetA
resource "aws_instance" "web_server-1" {
  ami                         = var.ubuntu_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.TF_PublicSubnetA.id
  associate_public_ip_address = true
  key_name                    = var.SSH_key
  vpc_security_group_ids      = [aws_security_group.PublicSG.id]

  tags = {
    Name = "Web Server 1"
  }
}


#Create 2nd VM in PublicSubnetB
resource "aws_instance" "web_server-2" {
  ami                         = var.ubuntu_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.TF_PublicSubnetB.id
  associate_public_ip_address = true
  key_name                    = var.SSH_key
  vpc_security_group_ids      = [aws_security_group.PublicSG.id]

  tags = {
    Name = "Web Server 2"
  }
}
