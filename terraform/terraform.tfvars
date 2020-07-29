
region                      = "us-east-1"
vpc_cidr                    = "10.0.0.0/16"
public_subnet_cidr          = "10.0.0.0/24"
private_subnet_cidr         = "10.0.1.0/24"
ssh_key                     = "terraform2"
instance_type               = "t2.medium"
environment                 = "staging"
associate_public_ip_address = true
master_count                = 1
