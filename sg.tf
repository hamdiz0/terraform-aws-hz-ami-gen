# security group for ssh
resource "aws_security_group" "custom_ami_sg" {
  name        = "custom_ami_sg"
}

# ssh
resource "aws_vpc_security_group_ingress_rule" "ami_instance_ssh_ingress" {
  security_group_id = aws_security_group.custom_ami_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "allow ssh"
}

# allow all outbound
resource "aws_vpc_security_group_egress_rule" "ami_instance_egress" {
  security_group_id = aws_security_group.custom_ami_sg.id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic from worker nodes"
  lifecycle {
    ignore_changes = all
  }
}