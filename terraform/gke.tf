resource "google_service_account" "hurb-gke" {
  account_id   = "hurb-gke"
  display_name = "hurb-gke"
}

resource "google_container_cluster" "hurb-gke-cluster" {
  name                     = "hurb-gke-cluster"
  location                 = "us-central1"
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = module.vpc-hurb.network_name
  subnetwork               = local.subnet_name
  min_master_version       = "1.23.11-gke.300"

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = local.cluster_pods_ip_cidr_range
    services_ipv4_cidr_block = local.cluster_services_ip_cidr_range
  }

  release_channel {
    channel = "STABLE"
  }
}

resource "google_container_node_pool" "hurb-gke-node-pool-default" {
  name               = "hurb-gke-node-pool-default"
  location           = "us-central1"
  cluster            = google_container_cluster.hurb-gke-cluster.name
  node_locations     = ["us-central1-a"]
  initial_node_count = 1

  upgrade_settings {
    strategy = "BLUE_GREEN"

    blue_green_settings {
      node_pool_soak_duration = "600s"

      standard_rollout_policy {
        batch_soak_duration = "10s"
        batch_node_count    = 1
      }
    }

    max_surge       = null
    max_unavailable = null
  }

  autoscaling {
    max_node_count = 1
    min_node_count = 1
  }

  node_config {
    preemptible     = false
    machine_type    = "e2-standard-2"
    service_account = google_service_account.hurb-gke.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }
}
