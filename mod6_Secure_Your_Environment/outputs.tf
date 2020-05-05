#Output for WebServers 

output "public_dns_web-server-1" {
  value       = aws_instance.web_server-1.public_dns
  description = "Public DNS for VM for SSH Access"
}

output "public_dns-jump-host-1" {
  value       = aws_instance.jump_host-1.public_dns
  description = "Public DNS for VM for SSH Access"
}

output "private_dns-private-server-1" {
  value       = aws_instance.private_server-1.private_dns
  description = "Public DNS for VM for SSH Access"
}
