Configuration done by Terraform


1. Creating S3 bucket + upload file to this bucket

2. Create EC2 instance and install NGINX

    * module provisioner is used (remote-exec)
    * to connect to deployed machine specific parameters are needed (public IP, username, connection method, private key)
      private key is provided as a variable with terraform command "terraform apply -var "private_key=$HOME/.ssh/<name_of_private_key>.pem"
    * /var/www/html/index.html is created with img src from S3 bucket
3. Create new VPC (10.1.0.0/16)
4. Create two subnets (PublicA - 10.1.1.0/24 and PrivateA - 10.1.2.0/24)
5. Create InternetGW
6. Create Route Table and add default route towards InternetGW
7. Update default SG (that was created after VPC creation with inbound traffic (ssh, http, https))
8. Create Security Group that is attached to Private-Server (only SSH is allowed from Default SG)
9. Create EC2 Instance (JumpHost) with different KeyPair 
10. Create EC2 Instance in PrivateA subnet (No access to/from Internet)

To Access EC2 Instance in PrivateA subnet first you need to log in into JumpHost and then to EC2 Instance in PrivateA subnet (Putty Peagent was used to test this with 2 different Private Keys)


