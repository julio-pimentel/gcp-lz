variable "default_region" {
  description = "network region name "
  type        = string
}

variable "terraform_service_account" {
  description = "Service account email of the account to impersonate to run Terraform."
  type        = string
}

variable "prefix" {
  description = "The prefix applied to the GCP project names."
  type        = string
}

variable "private_service_cidr" {
  description = "CIDR for private access"
  type        = string
}
variable "outbound_domain" {
  description = "Domain name of the outbound domain for DNS forwarding"
  type        = string
}
variable "target_name_server_addresses" {
  description = "Name server for DNS forwarding"
  type        = list(string)
}
