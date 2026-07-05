# creating a security group for the webserver 
resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = {
    Name = "webserver_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ingress" {

  for_each = var.ingress_ports

  security_group_id = aws_security_group.webserver_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
}

resource "aws_vpc_security_group_egress_rule" "allow_egress" {
  security_group_id = aws_security_group.webserver_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}