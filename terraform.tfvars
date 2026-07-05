region       = "ap-south-1"
machine_type = "t3.micro"
key_name     = "deployer-key"
ingress_ports = {
  ssh   = 22
  http  = 80
  https = 443
}
rds_ingress_ports = {
  mysql = 3306
}


# rds details
db_name     = "online_rest"
db_username = "root"
db_password = "1234567890"