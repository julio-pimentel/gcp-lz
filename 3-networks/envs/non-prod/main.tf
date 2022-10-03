data "google_projects" "network_project" {
  filter = "labels.application=shared-vpc-host-non-prod AND labels.environment=non-prod AND lifecycleState=ACTIVE"
}

module "network" {
  source = "../../modules/standard_shared_vpc"

  project_id                   = data.google_projects.network_project.projects[0].project_id
  prefix                       = var.prefix
  env                          = "non-prod"
  default_region               = var.default_region
  terraform_service_account    = var.terraform_service_account
  private_service_cidr         = var.private_service_cidr
  outbound_domain              = var.outbound_domain
  target_name_server_addresses = var.target_name_server_addresses

  nat_bgp_asn = 64514
  subnets = [
    {
      subnet_name           = ""
      subnet_ip             = ""
      subnet_region         = "us-central1"
      subnet_private_access = "true"
      subnet_flow_logs      = "false"

    },
    {
      subnet_name           = ""
      subnet_ip             = ""
      subnet_region         = "australia-southeast1"
      subnet_private_access = "true"
      subnet_flow_logs      = "false"
    }
  ]

#   secondary_ranges = {
#  }

}
