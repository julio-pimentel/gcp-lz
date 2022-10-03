variable "project_id" {
  description = "The project used to provision the resources"
  type        = string
}

variable "default_region" {
  description = "network region name "
  type        = string
}

variable "env" {
  description = "The prefix of the resource to distinguish between environments"
  type        = string
}

variable "prefix" {
  description = "prfix for the naming convensions "
  type        = string
}

variable "terraform_service_account" {
  description = "Service account email of the account to impersonate to run Terraform."
  type        = string
}

variable "private_service_cidr" {
  type = string
}

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
  default     = []
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

variable "nat_ipaddresses_num" {
  type        = number
  description = "Number of external IPs to reserve for Cloud NAT."
  default     = 4
}

variable "target_name_server_addresses" {
  description = "List of target name servers for forwarding zone."
  default     = []
  type        = list(string)
}

variable "outbound_domain" {
  description = "Zone domain, must end with a period."
  type        = string
}

variable "nat_bgp_asn" {
  type        = number
  description = "BGP ASN for NAT cloud routes."
}

variable "advertised_ip_ranges" {
  description = "The ranges to be advertised to on-premise "
  type        = list(string)
  default     = []
}
