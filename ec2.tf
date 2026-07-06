# creating aws instance
resource "aws_instance" "webserver" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.machine_type
  key_name      = aws_key_pair.deployer.key_name

  tags = {
    Name = "Terrafrom-AWS-Server"
  }

  vpc_security_group_ids = [aws_security_group.webserver_sg.id]

  user_data = templatefile("${path.module}/user_data.sh", {
    db_host     = aws_db_instance.rds_db.address
    db_port     = aws_db_instance.rds_db.port
    db_username = var.db_username
    db_password = var.db_password
    db_name     = var.db_name
    s3_region   = var.region
    s3_bucket   = var.s3_bucket_name
  })


  # attach the instance profile that attaches permissions to the S3 bucket
  iam_instance_profile = aws_iam_instance_profile.webserver_profile.name

}

output "instance_public_ip" {
  value = aws_instance.webserver.public_ip
}