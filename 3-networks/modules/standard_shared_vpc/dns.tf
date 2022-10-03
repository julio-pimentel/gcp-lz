module "base_gcr" {
  source      = "terraform-google-modules/cloud-dns/google"
  project_id  = var.project_id
  version     = "~> 3.1"
  type        = "private"
  name        = "${var.prefix}-${var.env}-private-googleapis"
  domain      = "googleapis.com."
  description = "Private DNS zone to configure"

  private_visibility_config_networks = [
    module.network.network_self_link
  ]

  recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["private.googleapis.com."]
    },
    {
      name    = "private"
      type    = "A"
      ttl     = 300
      records = ["199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"]
    },
  ]
}

module "private_gcr" {
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 3.1"
  project_id  = var.project_id
  type        = "private"
  name        = "${var.prefix}-${var.env}-private-gcr"
  domain      = "gcr.io."
  description = "Private DNS zone to configure gcr.io"

  private_visibility_config_networks = [
    module.network.network_self_link
  ]

  recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["gcr.io."]
    },
    {
      name    = ""
      type    = "A"
      ttl     = 300
      records = ["199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"]
    },
  ]
}

resource "google_dns_managed_zone" "forwarding" {
  provider = google-beta

  project     = var.project_id
  name        = "${var.prefix}-outbound-forwarding-zone"
  dns_name    = var.outbound_domain
  description = "Outbound forwarding"
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = module.network.network_self_link
    }
  }

  forwarding_config {
    dynamic "target_name_servers" {
      for_each = var.target_name_server_addresses
      content {
        ipv4_address = target_name_servers.value
      }
    }
  }
}

resource "google_dns_policy" "default_policy" {
  project                   = var.project_id
  name                      = "default-dns-policy"
  enable_inbound_forwarding = true
  enable_logging            = true
  networks {
    network_url = module.network.network_self_link
  }
}
