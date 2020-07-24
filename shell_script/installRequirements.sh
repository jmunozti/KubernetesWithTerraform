#!/bin/bash
echo "Begin"
echo "============================================"

sudo apt-get update
sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
sudo sh -c ' echo deb http://apt.kubernetes.io/ kubernetes-xenial main >> /etc/apt/sources.list.d/kubernetes.list'
sudo sh -c ' echo deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable >> /etc/apt/sources.list.d/kubernetes.list'
sudo apt-get update
sudo apt  install docker.io -y
sudo usermod -aG docker ${USER}
sudo systemctl start docker
sudo systemctl enable docker.service

# Install kubernetes components!
sudo apt-get install -y kubernetes-cni kubelet  kubeadm

echo "============================================"
echo "End"
