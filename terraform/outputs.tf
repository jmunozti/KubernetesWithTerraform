output "vpc_id" {
  value = module.vpc.vpc_id
}

output "bastion_public_ip" {
  value = module.bastion.public_ip
}

output "bastion_public_dns" {
  value = module.bastion.public_dns
}

output "master_public_dns" {
  value = module.ec2.public_dns
}

output "master_public_ip" {
  value = module.ec2.public_ip
}
