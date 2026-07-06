# creating a security group for the aws ec2 webserver 
resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = {
    Name = "webserver_sg"
  }
}

# creating ingress rules for the aws ec2 security group
resource "aws_vpc_security_group_ingress_rule" "allow_ingress" {

  for_each = var.ingress_ports

  security_group_id = aws_security_group.webserver_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
}

# creating egress rules for the aws ec2 security group
resource "aws_vpc_security_group_egress_rule" "allow_egress" {
  security_group_id = aws_security_group.webserver_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# creating a security group for the aws rds webserver 
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow MySQL from EC2"

  tags = {
    Name = "rds_sg"
  }
}

# creating ingress rules for the aws rds security group
resource "aws_vpc_security_group_ingress_rule" "allow_rds_ingress" {

  for_each = var.rds_ingress_ports

  security_group_id = aws_security_group.rds_sg.id

  from_port   = each.value
  ip_protocol = "tcp"
  to_port     = each.value

  # attach the ec2 security group to rds security group
  referenced_security_group_id = aws_security_group.webserver_sg.id
}

# creating egress rules for the aws rds security group
resource "aws_vpc_security_group_egress_rule" "allow_rds_egress" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}