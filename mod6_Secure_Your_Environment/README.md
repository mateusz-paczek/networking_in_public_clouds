Configuration done by Terraform


1. Creating S3 bucket + upload file to this bucket

2. Create EC2 instance and install NGINX

    * module provisioner is used (remote-exec) with bastion_host option
    * to connect to deployed machine SSH session with JumpHost is established and then JumpHost connects with WebServer from Terraform Provisioner
    * /var/www/html/index.html is created with img src from S3 bucket
3. Create new VPC (10.1.0.0/16)
4. Create two subnets (PublicA - 10.1.1.0/24 and PrivateA - 10.1.2.0/24)
5. Create InternetGW
6. Create Route Table and add default route towards InternetGW
7. Create WebServer_SG (allow HTTP, HTTPS from everywhere, SSH from JumpHost_SG; allow HTTP and HTTP to everywhere) and attach it to WebServer. 
8. Create JumpHost_SG (allow SSH from Specific Public IP; allow SSH to VPC Range) - attached to JumpHost 
9. Create Database_SG (allow tcp/1433, HTTP from WebServer_SG and DatabaseServer_SG, SSH from JumpHost_SG; allow tcp/1433 and HTTP to DatabaseServer_SG )
9. Create EC2 Instance (JumpHost) with different KeyPair 
10. Create EC2 Instance - equivalent to Database Server in PrivateA subnet (No access to/from Internet)

To Access EC2 Instance in PrivateA subnet first you need to log in into JumpHost and then to EC2 Instance in PrivateA subnet (Putty Peagent was used to test this with 2 different Private Keys)
11. Create EC2_Test user and assign policy that allows to see EC2 and Networking resources (EC2:Describe*) was used for that

