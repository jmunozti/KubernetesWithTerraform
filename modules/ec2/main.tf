resource "aws_instance" "my_ec2" {
  count                  = var.ec2_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  availability_zone      = var.availability_zone_1
  key_name               = var.ssh_key
  vpc_security_group_ids = [aws_security_group.ec2.id]

  user_data = <<EOF
  #!/bin/bash
  sudo yum update -y

  #Installing nginx
  sudo amazon-linux-extras install nginx1.12 -y
  sudo service nginx start
  sudo chkconfig nginx on

  #Sending /var/log/messages to CloudWatch because it records a variety of events,
  #such as the system error messages, system startups and shutdowns, change in the network configuration, etc.
  sudo yum install -y awslogs
  sudo systemctl start awslogsd
  sudo systemctl enable awslogsd.service

  logger $(uname -a)
EOF

  tags = {
    Name = format("%s_ec2", var.environment)
  }
}
