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