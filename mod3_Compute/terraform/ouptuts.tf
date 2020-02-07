#Output for WebServers 

output "public_dns1" {
  value       = aws_instance.web_server-1.public_dns
  description = "Public DNS for VM for SSH Access"
}


output "public_dns_for_S3_bucket" {
  value       = aws_s3_bucket.test_bucket.website_endpoint
  description = "Public DNS for S3 Website object"
}



