# Overview
The purpose of this step is to set up shared VPCs with default DNS, NAT, Private Service networking, onprem partner interconnect and baseline firewall rules for each environment.


## Prerequisites

1. 0-bootstrap executed successfully.
1. 1-org executed successfully.
1. 2-environments executed successfully.

## Resources (Per environment)

This module performs the following actions:

1. Set up private.googleapis.com DNS zone
1. Set up default firewalls per environment
   1. Ingress for IAP TCP and RDP forwarding 
   1. Ingress for HTTP/TCP Load Balancer health check
   1. Deny all egress firewall
1. Set up partner interconnect
1. Set up inbound DNS and outbound DNS forwarding
1. Set up VPC and subnets
1. Set up Private Service Connection
1. Set up a project for Service accounts

## CFT Modules

| Module Name | Version |
|------|---------|
| [terraform-google-modules/project-factory/google](https://registry.terraform.io/modules/terraform-google-modules/project-factory/google/latest) | ~> 10.1
| [terraform-google-modules/cloud-dns/google](https://registry.terraform.io/modules/terraform-google-modules/project-factory/google/latest) | ~> 3.1
| [terraform-google-modules/network/google](https://registry.terraform.io/modules/terraform-google-modules/project-factory/google/latest) | ~> 3.0


## Terraform Providers

| Name | Version |
|------|---------|
| terraform | >0.12, <0.14 |
| google | ~> 3.52 |
| google-beta | ~> 3.52 |
| null | ~> 2.1 |
| random | ~> 2.3 |
