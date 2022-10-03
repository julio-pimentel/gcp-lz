resource "google_compute_firewall" "deny_all_egress" {
  name      = "${var.prefix}-${var.env}-deny-all"
  network   = module.network.network_name
  project   = var.project_id
  direction = "EGRESS"
  priority  = 65535

  deny {
    protocol = "all"
  }

  destination_ranges = ["0.0.0.0/0"]


}

resource "google_compute_firewall" "allow_private_api_egress" {
  name      = "${var.prefix}-${var.env}-egress-allowgcpapis"
  network   = module.network.network_name
  project   = var.project_id
  direction = "EGRESS"
  priority  = 1000
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  destination_ranges = [local.private_googleapis_cidr]
  target_tags        = ["allow-out-gcp-internal"]
}

resource "google_compute_firewall" "allow_lb" {
  name      = "${var.prefix}-${var.env}-ingress-allowlb"
  network   = module.network.network_name
  project   = var.project_id
  priority  = 1000
  direction = "INGRESS"
  allow {
    protocol = "tcp"
  }
  source_ranges = concat(data.google_netblock_ip_ranges.health_checkers.cidr_blocks_ipv4, data.google_netblock_ip_ranges.legacy_health_checkers.cidr_blocks_ipv4)
  target_tags   = ["allow-in-lb"]
}

