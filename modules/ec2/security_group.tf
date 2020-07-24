resource "aws_security_group" "ec2" {
  name        = "EC2 host SG"
  description = "Allow SSH access to EC2 host though a bastion"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "EC2 Security Group"
  }
}

resource "aws_security_group_rule" "ssh" {
  protocol          = "TCP"
  from_port         = 22
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "kubernetes_api_server" {
  protocol          = "TCP"
  from_port         = 6443
  to_port           = 6443
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "etcd_server" {
  protocol          = "TCP"
  from_port         = 2379
  to_port           = 2380
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "kubelet_health_check" {
  protocol          = "TCP"
  from_port         = 10250
  to_port           = 10250
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "kubelet_controller_manager" {
  protocol          = "TCP"
  from_port         = 10252
  to_port           = 10252
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "kubelet_api" {
  protocol          = "TCP"
  from_port         = 10255
  to_port           = 10255
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "internet" {
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
}
