#!/bin/bash
set -e
echo "Begin"
echo "============================================"
sudo kubeadm init --pod-network-cidr=10.0.0.0/16 

# By now the master node should be ready!
mkdir -p $HOME/.kube
sudo cp --remove-destination /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install flannel
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.12.0/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml
# Make master node a running worker node too!
#kubectl taint nodes --all node-role.kubernetes.io/master-

#Installing Helm3
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

#Adding Helm3 repo
echo "Adding Helm3 repo"
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
sleep 20

#Install Ingress
echo "Install Ingress"
kubectl create ns nginx
helm install nginx stable/nginx-ingress --namespace nginx --set rbac.create=true --set controller.publishService.enabled=true
#kubectl --namespace nginx get services -o wide -w nginx-nginx-ingress-controller
sleep 20

echo "============================================"
echo "End"
