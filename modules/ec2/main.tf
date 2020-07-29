resource "aws_instance" "my_ec2" {
  count                  = var.ec2_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  availability_zone      = var.availability_zone_1
  key_name               = var.ssh_key
  vpc_security_group_ids = [aws_security_group.ec2.id]

  tags = {
    Name = format("%s_ec2", var.environment)
  }

  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y apt-transport-https
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
sudo sh -c ' echo deb http://apt.kubernetes.io/ kubernetes-xenial main >> /etc/apt/sources.list.d/kubernetes.list'
sudo apt-get update
sudo apt-get install -y docker.io
sudo usermod -aG docker ubuntu
sudo systemctl start docker
sudo systemctl enable docker
sudo apt-get install -y \
        kubelet \
        kubeadm \
        kubernetes-cni \
        kubectl
EOF

}
