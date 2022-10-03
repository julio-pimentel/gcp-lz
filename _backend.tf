terraform {
  backend "gcs" {
    bucket  = "tf-remote-state-pimentel"
    prefix  = "state"
  }  
  required_version = ">0.13"  
  required_providers { 
    google = {
      source = "hashicorp/google"
      version = "3.82.0"
    }
  }
}
provider "google" {
  project = "contini-5f2302a31dbe0b9a"
  region  = "australia-southeast1"
  zone    = "australia-southeast1-a
}
