#Output for WebServers 

output "public_dns1" {
  value       = aws_instance.web_server-1.public_dns
  description = "Public DNS for VM for SSH Access"
}


output "public_dns2" {
  value       = aws_instance.web_server-2.public_dns
  description = "Public DNS for VM for SSH Access"
}
