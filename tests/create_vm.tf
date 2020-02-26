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

resource "aws_instance" "web-server" {
  ami                         = data.aws_ami.ubuntu-18_04.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = var.SSH_key
}



##################################################################################
# OUTPUT
##################################################################################

output "aws_instance_public_dns" {
  value = aws_instance.web-server.public_dns
}
