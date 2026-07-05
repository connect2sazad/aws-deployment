# creating aws instance
resource "aws_instance" "webserver" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.machine_type
  key_name      = aws_key_pair.deployer.key_name

  tags = {
    Name = "Terrafrom-AWS-Server"
  }

  vpc_security_group_ids = [aws_security_group.webserver_sg.id]

  user_data = file("${path.module}/user_data.sh")

}

output "instance_public_ip" {
  value = aws_instance.webserver.public_ip
}