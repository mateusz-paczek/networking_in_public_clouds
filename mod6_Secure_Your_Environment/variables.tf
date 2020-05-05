variable "aws_region" {
  description = "Region for the VPC"
  default     = "eu-west-1"
}

variable "s3_object_name" {
  type    = string
  default = "camp_nou.jpg"
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

#Variable used to specify Private Key (used to connect to VM with Terraform Provisioner)
variable "private_key" {}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.1.0.0/16"
}

variable "public_subnetA" {
  description = "CIDR for Public Subnet A"
  default     = "10.1.1.0/24"
}


variable "private_subnetA" {
  description = "CIDR for Private Subnet A"
  default     = "10.1.2.0/24"
}

