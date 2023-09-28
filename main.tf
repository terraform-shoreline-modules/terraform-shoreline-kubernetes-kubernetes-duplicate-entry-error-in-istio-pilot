terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "duplicate_entry_error_in_istio_pilot" {
  source    = "./modules/duplicate_entry_error_in_istio_pilot"

  providers = {
    shoreline = shoreline
  }
}