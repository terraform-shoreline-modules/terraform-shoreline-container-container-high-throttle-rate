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

module "container_high_throttle_rate_incident" {
  source    = "./modules/container_high_throttle_rate_incident"

  providers = {
    shoreline = shoreline
  }
}