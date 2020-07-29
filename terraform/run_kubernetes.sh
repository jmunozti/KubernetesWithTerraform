#!/bin/bash

echo "Begin"
echo "============================================"
bastion=$(terraform output -json | jq -r '.bastion_public_dns.value')
masterIP=$(terraform output -json | jq -r '.master_public_ip.value')

#Starting Kubernetes' Master Node
ssh -i ../keyPair/keyPair.pem ubuntu@$masterIP -o "proxycommand ssh -W %h:%p -i ../keyPair/keyPair.pem ubuntu@$bastion" 'bash -s' < ../shell_script/startMaster.sh
sleep 20
ssh -i ../keyPair/keyPair.pem ubuntu@$masterIP -o "proxycommand ssh -W %h:%p -i ../keyPair/keyPair.pem ubuntu@$bastion" 'bash -s' < ../shell_script/deployApps.sh
sleep 20
token=$(ssh -i ../keyPair/keyPair.pem ubuntu@$masterIP -o "proxycommand ssh -W %h:%p -i ../keyPair/keyPair.pem ubuntu@$bastion" 'kubeadm token list' |  awk -F ' ' 'NR==2{print $1}' )
sleep 60

asg=$(aws autoscaling describe-auto-scaling-groups | jq -r '[.AutoScalingGroups[0]] | .[0].AutoScalingGroupName')

for i in `aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name $asg | grep -i instanceid  | awk '{ print $2}' | cut -d',' -f1| sed -e 's/"//g'`
do
 for j in `aws ec2 describe-instances --instance-ids $i  | grep -i PublicIpAddress | awk '{ print $2 }' | head -1 | cut -d"," -f1 | tr -d '"' `
 do
   echo "Joining Workers. IP: "$j
    ssh -i ../keyPair/keyPair.pem ubuntu@$j -o "proxycommand ssh -W %h:%p -i ../keyPair/keyPair.pem ubuntu@$bastion" "sudo kubeadm join $masterIP:6443 --token $token --discovery-token-unsafe-skip-ca-verification"
 done
done;

sleep 5

#Verifying Kubernetes
ssh -i ../keyPair/keyPair.pem ubuntu@$masterIP -o "proxycommand ssh -W %h:%p -i ../keyPair/keyPair.pem ubuntu@$bastion" 'kubectl get all && kubectl get nodes'

echo "============================================"
echo "End"
