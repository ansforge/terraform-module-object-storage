terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 2.8.0"
    }
  }
}

provider "ovh" {
  endpoint = var.ovh.endpoint
}