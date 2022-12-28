resource "google_storage_bucket" "hurb-terraform" {
  name          = "hurb-terraform"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"

  versioning {
    enabled = true
  }
}
