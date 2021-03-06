#Define AWS as a provider (region defined in variables.tf
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
# RESOURCE
####################################################################################


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




#Create Web Server in default VPC
resource aws_instance "web_server-1" {
  ami                         = data.aws_ami.ubuntu-18_04.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = var.SSH_key

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

}


