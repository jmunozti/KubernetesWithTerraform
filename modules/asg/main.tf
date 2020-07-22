resource "aws_launch_configuration" "asg-launch-config" {
  image_id             = var.ami_id
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.asg.id]
  key_name             = var.ssh_key
  iam_instance_profile = "arn:aws:iam::005488327456:instance-profile/EC2"

  user_data = <<EOF
#!/bin/bash
sudo yum update -y

#Installing docker
sudo amazon-linux-extras install docker
sudo yum install docker
sudo service docker start
sudo usermod -a -G docker ec2-user

sudo swapoff -a
sudo sed -i '2s/^/#/' /etc/fstab

curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.7/2020-07-08/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin

#Sending /var/log/messages to CloudWatch because it records a variety of events,
#such as the system error messages, system startups and shutdowns, change in the network configuration, etc.
sudo yum install -y awslogs
sudo systemctl start awslogsd
sudo systemctl enable awslogsd.service

logger $(uname -a)
logger $(kubectl version --short --client)
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.asg-launch-config.id
  min_size             = var.min_size
  max_size             = var.max_size
  health_check_type    = var.health_check_type
  vpc_zone_identifier  = [var.vpc_zone_identifier]

  tag {
    key                 = "Name"
    value               = format("%s_asg", var.environment)
    propagate_at_launch = true
  }
}
