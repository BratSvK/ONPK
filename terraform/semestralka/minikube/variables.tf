# --- root/variables.tf ---

variable "username" {
  type = string
}
variable "password" {
  type = string
}
variable "tenant_name" {
  type = string
}

variable "network_name" {
  type = string
}
variable "router_name" {
  type = string
}

variable "flavor_name" {
  type = string
  default = "ONPK_large"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "key_pair_name" {
  type = string
}

variable "project" {
  type = string
}