terraform {
  backend "gcs" {
    bucket = "gcp-tfstate"  #TODO: Change this
    prefix = "terraform/networks/prod/state"
  }
}
