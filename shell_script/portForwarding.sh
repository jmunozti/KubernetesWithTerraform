ssh -i /home/jorge/nearsoft/terraform2.pem ubuntu@"3.237.174.28" -o 'proxycommand ssh -W %h:%p -i /home/jorge/nearsoft/terraform2.pem ubuntu@ec2-18-209-213-77.compute-1.amazonaws.com' 'bash -s' < startMaster.sh 
ssh -i /home/jorge/nearsoft/terraform2.pem ubuntu@"3.94.153.16" -o 'proxycommand ssh -W %h:%p -i /home/jorge/nearsoft/terraform2.pem ubuntu@ec2-18-209-213-77.compute-1.amazonaws.com' 'bash -s' < startMaster.sh 