variable "subnet_id" {
  description = "The VPC Subnet ID to launch in."
}

variable "ssh_key" {
  description = "The key name of the Key Pair to use for the instance."
}

variable "allowed_hosts" {
  description = "CIDR blocks of trusted networks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "instance_type" {
  description = "The type of instance to start."
  default     = "t2.micro"
}

variable "disk_size" {
  description = "The size of the root volume in gigabytes."
  default     = 10
}

variable "internal_networks" {
  type        = list(string)
  description = "Internal network CIDR blocks."
}

variable "ami_id" {
  default = "ami-08f3d892de259504d"
}

data "aws_subnet" "public" {
  id = var.subnet_id
}

variable "environment" {
  default = "The Environment name to use."
}
