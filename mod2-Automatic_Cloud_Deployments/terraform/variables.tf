variable "aws_region" {
  description = "Region for the VPC"
  default     = "eu-west-1"
}

variable "ubuntu_ami" {
  description = "Specify AMI for AWS Region"
  default     = "ami-02df9ea15c1778c9c"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "SSH_key" {
  type    = string
  default = "testkeypair"
}


variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.1.0.0/16"
}

variable "public_subnetA" {
  description = "CIDR for Public Subnet A"
  default     = "10.1.1.0/24"
}

variable "public_subnetB" {
  description = "CIDR for Public Subnet B"
  default     = "10.1.129.0/24"
}


variable "private_subnetA" {
  description = "CIDR for Private Subnet A"
  default     = "10.1.2.0/24"
}

variable "private_subnetB" {
  description = "CIDR for Private Subnet B"
  default     = "10.1.130.0/24"
}
