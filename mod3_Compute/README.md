Configuration done by Terraform

1. Creating S3 bucket + upload file to this bucket

2. Creating VM and install nginx: 
- module provisioner is used (remote-exec)
- to connect to deployed machine specific parameters are needed (public IP, username, connection method, private key)
- private key is provided as a variable with terraform command "terraform apply -var "private_key=$HOME/.ssh/<name_of_private_key>.pem"
- /var/www/html/index.html is created with img src from S3 bucket

There is an assumption that default SG allows HTTP inbound