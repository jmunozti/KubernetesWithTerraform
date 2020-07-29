resource "aws_security_group" "asg" {
  name        = "ASG security group"
  description = "Allow access to EC2 instances"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "ASG Security Group"
  }
}

resource "aws_security_group_rule" "ssh" {
  protocol          = "TCP"
  from_port         = 22
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.asg.id
}

resource "aws_security_group_rule" "kubelet_health_check" {
  protocol          = "TCP"
  from_port         = 10250
  to_port           = 10250
  type              = "ingress"
  cidr_blocks       = var.allowed_hosts
  security_group_id = aws_security_group.asg.id
}

resource "aws_security_group_rule" "external_applications" {
  protocol          = "TCP"
  from_port         = 30000
  to_port           = 32767
  type              = "ingress"
  cidr_blocks       = var.allowed_hosts
  security_group_id = aws_security_group.asg.id
}

resource "aws_security_group_rule" "kubelet_api" {
  protocol          = "TCP"
  from_port         = 10255
  to_port           = 10255
  type              = "ingress"
  cidr_blocks       = var.allowed_hosts
  security_group_id = aws_security_group.asg.id
}

resource "aws_security_group_rule" "internet" {
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.asg.id
}

resource "aws_security_group_rule" "intranet" {
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  type              = "egress"
  cidr_blocks       = var.internal_networks
  security_group_id = aws_security_group.asg.id
}
