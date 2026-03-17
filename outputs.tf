output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "alb_dns_name" {
  value = module.alb.alb_dns
}

output "apache_instance_id" {
  value = module.amazon_ec2.instance_id
}

output "nginx_instance_id" {
  value = module.ubuntu_ec2.instance_id
}

output "apache_url" {
  value = "http://${module.alb.alb_dns}/apache"
}

output "nginx_url" {
  value = "http://${module.alb.alb_dns}/nginx"
}

# output "amazon_instance_public_ip" {
#   description = "Public IP of Amazon EC2 instance"
#   value       = module.amazon_ec2.public_ip
# }

# output "ubuntu_instance_public_ip" {
#   description = "Public IP of Ubuntu EC2 instance"
#   value       = module.ubuntu_ec2.public_ip
# }

# output "amazon_private_key_path" {
#   description = "Private key file for Amazon EC2"
#   value       = module.amazon_keypair.private_key_path
# }

# output "ubuntu_private_key_path" {
#   description = "Private key file for Ubuntu EC2"
#   value       = module.ubuntu_keypair.private_key_path
# }