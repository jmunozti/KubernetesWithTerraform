#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "You must supply the bastion public dns"
    exit
fi

echo "Begin"
echo "============================================"
bastion=$1

#rm portForwarding.sh
#echo
asg=$(aws autoscaling describe-auto-scaling-groups | jq -r '[.AutoScalingGroups[0]] | .[0].AutoScalingGroupName')

for i in `aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name $asg | grep -i instanceid  | awk '{ print $2}' | cut -d',' -f1| sed -e 's/"//g'`
do
 for j in `aws ec2 describe-instances --instance-ids $i  | grep -i PublicIpAddress | awk '{ print $2 }' | head -1 | cut -d"," -f1 | tr -d '"' `
 do
   echo "Joining Workers. IP: "$j
   #echo "ssh -i /home/jorge/nearsoft/terraform2.pem ubuntu@$j -o 'proxycommand ssh -W %h:%p -i /home/jorge/nearsoft/terraform2.pem ubuntu@$bastion' 'bash -s' < startMaster.sh "  >> portForwarding.sh
   ssh -i /home/jorge/nearsoft/terraform2.pem ubuntu@$j -o "proxycommand ssh -W %h:%p -i /home/jorge/nearsoft/terraform2.pem ubuntu@$bastion" 'bash -s' < joinWorkers.sh
 done
#ssh -i terraform2.pem ec2-user@10.0.1.4 -o "proxycommand ssh -W %h:%p -i terraform2.pem ec2-user@ec2-3-236-89-142.compute-1.amazonaws.com"
done;

echo "============================================"
echo "End"
