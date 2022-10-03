resource "google_compute_address" "nat_external_addresses" {
  count   = var.nat_ipaddresses_num
  project = var.project_id
  name    = "nat-external-address-${count.index}"
  region  = var.default_region
}

resource "google_compute_router" "nat_router_region" {
  name    = "${var.prefix}-${var.env}-vpc-${var.default_region}-nat-router"
  project = var.project_id
  region  = var.default_region
  network = module.network.network_self_link

  bgp {
    asn = var.nat_bgp_asn
  }
}

resource "google_compute_router_nat" "egress_nat_region" {
  name                               = "${var.prefix}-${var.env}-vpc-${var.default_region}-nat"
  project                            = var.project_id
  router                             = google_compute_router.nat_router_region.name
  region                             = var.default_region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.nat_external_addresses.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}
