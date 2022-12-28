terraform {
  backend "gcs" {
    bucket = "hurb-terraform"
    prefix = "tfstate"
  }
}
