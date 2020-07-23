#!/bin/bash
echo "Begin"
echo "============================================"

sudo apt-get update
sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
sudo sh -c ' echo deb http://apt.kubernetes.io/ kubernetes-xenial main >> /etc/apt/sources.list.d/kubernetes.list'
sudo sh -c ' echo deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable >> /etc/apt/sources.list.d/kubernetes.list'
sudo apt-get update && sudo apt-get install -y docker-ce=17.03.2~ce-0~ubuntu-xenial --allow-unauthenticated
sudo usermod -aG docker ${USER}
sudo apt-get remove cri-tools
sudo systemctl stop docker
sudo modprobe overlay
sudo sh -c 'echo {\"storage-driver\": \"overlay2\"} > /etc/docker/daemon.json'
sudo rm -rf /var/lib/docker/*
sudo systemctl start docker

# Install kubernetes components!
sudo apt-get install -y \
        kubelet=1.10.0-0 \
        kubeadm=1.10.0-0 \
        kubernetes-cni=0.6.0-00 \
        --allow-downgrades --allow-unauthenticated

echo "============================================"
echo "End"
