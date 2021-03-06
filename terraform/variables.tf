
variable "region" {
  description = "Defines the AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "Defines the VPC's CIDR block"
  default     = "10.0.0.0/16"
}

variable "tenancy" {
  description = "Defines the tenancy option for instances into the VPC."
  default     = "default"
}

variable "public_subnet_cidr" {
  description = "Defines a public subnet CIDR"
  default     = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  description = "Defines a private subnet CIDR"
  default     = "10.0.1.0/24"
}

variable "ssh_key" {
  description = "The key name of the Key Pair to use for the instance."
  default     = "bastion"
}

variable "instance_type" {
  description = "The type of instance to start."
  default     = "t2.micro"
}

variable "min_size" {
  description = "The minimum number of instances."
  default     = 2
}

variable "max_size" {
  description = "The maximum number of instances."
  default     = 2
}

variable "vpc_zone_identifier" {
  default = "List of subnet IDs to use."
}

variable "health_check_type" {
  default = "EC2"
}

variable "environment" {
  default = "The Environment name to use."
}

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

variable "associate_public_ip_address" {
  description = "Defines if an EC2 Instance must to have a Public Ip"
  default     = true
}

variable "master_count" {
  description = "Defines the number of Kubernetes' Mater nodes"
  default     = "1"
}
