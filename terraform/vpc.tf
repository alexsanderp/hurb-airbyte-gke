module "vpc-hurb" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.2"

  project_id   = "hurb-373018"
  network_name = "vpc-hurb"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "subnet-us-central1"
      subnet_ip             = "10.222.0.0/16"
      subnet_region         = "us-central1"
      subnet_private_access = "true"
    }
  ]

  secondary_ranges = {
    subnet-us-central1 = [{
      range_name    = "gke-hurb-gke-cluster-services-9cd6c050"
      ip_cidr_range = local.cluster_services_ip_cidr_range
      },
      {
        range_name    = "gke-hurb-gke-cluster-pods-9cd6c050"
        ip_cidr_range = local.cluster_pods_ip_cidr_range
    }]
  }

  routes = [
    {
      name              = "access-internet"
      description       = "access internet"
      destination_range = "0.0.0.0/0"
      tags              = "vpc-hurb"
      next_hop_internet = "true"
    }
  ]
}

resource "google_compute_router" "vpc-hurb-nat" {
  name    = "vpc-hurb-nat"
  region  = "us-central1"
  network = module.vpc-hurb.network_id
}

resource "google_compute_router_nat" "vpc-hurb-nat" {
  name                               = "vpc-hurb-nat"
  router                             = google_compute_router.vpc-hurb-nat.name
  region                             = google_compute_router.vpc-hurb-nat.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
