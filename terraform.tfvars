region       = "ap-south-1"
machine_type = "t3.micro"
key_name     = "deployer-key"
ingress_ports = {
  ssh   = 22
  http  = 80
  https = 443
}