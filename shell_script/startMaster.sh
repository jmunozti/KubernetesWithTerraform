#!/bin/bash
echo "Begin"
echo "============================================"

#!/bin/bash
set -e
sudo kubeadm init --pod-network-cidr=10.0.0.0/16

# By now the master node should be ready!
mkdir -p $HOME/.kube
sudo cp --remove-destination /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install flannel
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.12.0/Documentation/kube-flannel.yml
# Make master node a running worker node too!
kubectl taint nodes --all node-role.kubernetes.io/master-

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

#Deploying an app
echo "Deploying an app"
kubectl create deployment hello-app --image=gcr.io/google-samples/hello-app:1.0
kubectl expose deployment hello-app --port 8080 --target-port 8080
kubectl apply -f app/hello-app-ingress.yaml
sleep 20

#Deploying some apps with Helm3
echo "Deploying some apps with Helm3"
helm install --values mychart/values.yaml mychart/ --generate-name

kubectl create ns monitoring
helm install prometheus stable/prometheus --namespace monitoring
kubectl --namespace default get pods -l "release=my-prometheus-operator"
helm list
sleep 20

echo "Get all"
kubectl get all

echo "============================================"
echo "End"
