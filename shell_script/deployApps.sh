#!/bin/bash
set -e
echo "Begin"
echo "============================================"

#Deploying an app
rm -rf /home/ubuntu/KubernetesWithTerraform
git clone https://github.com/jmunozti/KubernetesWithTerraform.git


echo "Deploying an app"
cd /home/ubuntu/KubernetesWithTerraform/app/

#kubectl delete deploy/hello-app svc/hello-app
kubectl create deployment hello-app --image=gcr.io/google-samples/hello-app:1.0
kubectl expose deployment hello-app --port 80 --target-port 8080
kubectl apply -f hello-app-ingress.yaml
sleep 5

#Deploying some apps with Helm3
echo "Deploying some apps with Helm3"
cd /home/ubuntu/KubernetesWithTerraform/
helm install --values mychart/values.yaml mychart/ --generate-name

kubectl create ns monitoring
helm install prometheus stable/prometheus --namespace monitoring
kubectl --namespace default get pods -l "release=my-prometheus-operator"
helm list
sleep 5

echo "Get all"
kubectl get all

echo "============================================"
echo "End"
