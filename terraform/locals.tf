locals {
  subnet_name                    = "subnet-us-central1"
  subnet_cidr_block              = "10.222.0.0/16"
  cluster_master_ip_cidr_range   = "192.17.0.0/28"
  cluster_pods_ip_cidr_range     = "192.16.128.0/17"
  cluster_services_ip_cidr_range = "192.168.1.0/24"
}
