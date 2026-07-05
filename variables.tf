variable "machine_type" {
  type = string
}

variable "region" {
  type = string
}

variable "key_name" {
  type = string
}

variable "ingress_ports" {
  type = map(any)
}

variable "rds_ingress_ports" {
  type = map(any)
}


# rds
variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}