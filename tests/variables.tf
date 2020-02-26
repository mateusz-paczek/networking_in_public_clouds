variable "aws_region" {
  description = "Region for the VPC"
  default     = "eu-west-1"
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



