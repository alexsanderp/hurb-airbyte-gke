provider "google" {
  project     = "hurb-373018"
  credentials = file("credentials.json")
  region      = "us-central1"
  zone        = "us-central1-a"
}

provider "google-beta" {
  project     = "hurb-373018"
  credentials = file("credentials.json")
  region      = "us-central1"
  zone        = "us-central1-a"
}
