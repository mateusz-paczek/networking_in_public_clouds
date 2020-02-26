#Define AWS as a provider (region defined in variables.tf)
provider "aws" {
  region = var.aws_region
}



####################################################################################
# DATA
####################################################################################

#Latest Ubuntu 18.04 image)
data "aws_ami" "ubuntu-18_04" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



####################################################################################
# RESOURCES
####################################################################################


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


#Create Private Subnet A and associate with previously created AWS VPC (CIDR_BLOCK defined in variables.tf)
resource "aws_subnet" "TF_PrivateSubnetA" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = var.private_subnetA
  availability_zone = "eu-west-1a"

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

#Create Routing Table association with PublicSubnetA
resource "aws_route_table_association" "publicA" {
  subnet_id      = aws_subnet.TF_PublicSubnetA.id
  route_table_id = aws_route_table.PublicRT.id
}



#Update default Security Group 
resource "aws_default_security_group" "default" {

  vpc_id = aws_vpc.tf_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Default Security Group"
  }
}



#Create Security Group for PrivateSubnet
resource "aws_security_group" "PrivateSG" {
  name        = "PrivateSG"
  description = "Allow SSH Traffic In"
  vpc_id      = aws_vpc.tf_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_default_security_group.default.id]
    #cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PrivateSubnet Security Group"
  }
}
#Create S3 bucket with public acl
resource "aws_s3_bucket" "test_bucket" {
  bucket = "mpaczek-test"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

#Upload jpg file to previously created bucket
resource "aws_s3_bucket_object" "test_bucket_object" {
  bucket = aws_s3_bucket.test_bucket.id
  key    = var.s3_object_name
  source = var.s3_object_name
  acl    = "public-read"
}

#Create 1st VM in PublicSubnetA
resource "aws_instance" "web_server-1" {
  ami                         = data.aws_ami.ubuntu-18_04.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.TF_PublicSubnetA.id
  associate_public_ip_address = true
  key_name                    = var.SSH_key
  #vpc_security_group_ids      = [aws_security_group.default.id]

  connection {
    host        = aws_instance.web_server-1.public_ip
    user        = "ubuntu"
    type        = "ssh"
    private_key = file(var.private_key)
  }


  provisioner "file" {
    content     = "<img src=http://${aws_s3_bucket.test_bucket.website_endpoint}/${var.s3_object_name} />"
    destination = "/tmp/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo cp /tmp/index.html /var/www/html/index.html",
      "sudo service nginx start",

    ]
  }
  tags = {
    Name = "Web Server 1"
  }
}

#Create JumpHost VM in PublicSubnetA
resource "aws_instance" "jump_host-1" {
  ami                         = data.aws_ami.ubuntu-18_04.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.TF_PublicSubnetA.id
  associate_public_ip_address = true
  key_name                    = "jumphost"
  tags = {
    Name = "Jump Host 1"
  }
}

#Create EC2 Instance in Private Subnet
resource "aws_instance" "private_server-1" {
  ami                    = data.aws_ami.ubuntu-18_04.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.TF_PrivateSubnetA.id
  key_name               = var.SSH_key
  vpc_security_group_ids = [aws_security_group.PrivateSG.id]
  tags = {
    Name = "Private Server 1"
  }
}
