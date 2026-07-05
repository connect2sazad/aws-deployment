resource "aws_db_instance" "rds_db" {

  identifier = "terraform-mysql"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  publicly_accessible = false

  skip_final_snapshot = true

  deletion_protection = false

  multi_az = false
}

output "rds_endpoint"{
    value = aws_db_instance.rds_db.endpoint
}