output "private_ip" {
  value = aws_instance.my_ec2[0].private_ip
}

output "public_ip" {
  value = aws_instance.my_ec2[0].public_ip
}

output "public_dns" {
  value = aws_instance.my_ec2[0].public_dns
}
