resource "aws_launch_configuration" "asg-launch-config" {
  image_id                    = var.ami_id
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.asg.id]
  key_name                    = var.ssh_key
  iam_instance_profile        = "arn:aws:iam::005488327456:instance-profile/EC2"
  associate_public_ip_address = var.associate_public_ip_address

  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
sudo sh -c ' echo deb http://apt.kubernetes.io/ kubernetes-xenial main >> /etc/apt/sources.list.d/kubernetes.list'
sudo sh -c ' echo deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable >> /etc/apt/sources.list.d/kubernetes.list'
sudo apt-get update && sudo apt-get install -y docker-ce --allow-unauthenticated
sudo usermod -aG docker ubuntu
sudo apt-get remove cri-tools
sudo systemctl stop docker
sudo modprobe overlay
sudo sh -c 'echo {\"storage-driver\": \"overlay2\"} > /etc/docker/daemon.json'
sudo rm -rf /var/lib/docker/*
sudo systemctl start docker

# Install kubernetes components!
sudo apt-get install -y \
        kubelet \
        kubeadm \
        kubernetes-cni \
        --allow-downgrades --allow-unauthenticated
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
