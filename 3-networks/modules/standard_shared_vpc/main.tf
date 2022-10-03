locals {
  private_googleapis_cidr = "199.36.153.8/30"
}

module "network" {
  source           = "terraform-google-modules/network/google"
  project_id       = var.project_id
  version          = "~> 3.0"
  network_name     = "${var.prefix}-sharedvpc-${var.env}"
  shared_vpc_host  = "true"
  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges

  routes = concat(
    [{
      name              = "allow-google-apis"
      description       = "Route through IGW to allow private google api access."
      destination_range = local.private_googleapis_cidr
      next_hop_internet = "true"
      priority          = "1000"
      tags              = "allow-out-gcp-internal"
    }],
    [{
      name              = "allow-out-public-internet"
      description       = "Tag based route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "allow-out-public-internet"
      next_hop_internet = "true"
      priority          = "1000"
    }]
  )
}

/******************************************
  Cloud Interconnect
 *****************************************/

resource "google_compute_router" "megaport_router_a" {
  name    = "megaport-router-a-${var.env}"
  project = var.project_id
  region  = var.default_region
  network = module.network.network_self_link

  // The specified ASN number is required for partner interconnect (https://cloud.google.com/network-connectivity/docs/interconnect/tutorials/partner-creating-9999-availability#create-cloud-routers)
  bgp {
    advertise_mode = "CUSTOM"
    asn            = 16550

    dynamic "advertised_ip_ranges" {
      for_each = toset(var.advertised_ip_ranges)
      content {
        range = advertised_ip_ranges.value
      }
    }
  }
}

resource "google_compute_router" "megaport_router_b" {
  name    = "megaport-router-b-${var.env}"
  project = var.project_id
  region  = var.default_region
  network = module.network.network_self_link

  // The specified ASN number is required for partner interconnect (https://cloud.google.com/network-connectivity/docs/interconnect/tutorials/partner-creating-9999-availability#create-cloud-routers)
  bgp {
    advertise_mode = "CUSTOM"
    asn            = 16550

    dynamic "advertised_ip_ranges" {
      for_each = toset(var.advertised_ip_ranges)
      content {
        range = advertised_ip_ranges.value
      }
    }
  }
}
resource "google_compute_interconnect_attachment" "on_prem_attachment_a" {
  name                     = "default-interconnect-a-${var.env}"
  project                  = var.project_id
  type                     = "PARTNER"
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  router                   = google_compute_router.megaport_router_a.self_link
  region                   = var.default_region
  admin_enabled            = true
}

resource "google_compute_interconnect_attachment" "on-prem-attachment-b" {
  name                     = "default-interconnect-b-${var.env}"
  project                  = var.project_id
  type                     = "PARTNER"
  edge_availability_domain = "AVAILABILITY_DOMAIN_2"
  router                   = google_compute_router.megaport_router_b.self_link
  region                   = var.default_region
  admin_enabled            = true
}
