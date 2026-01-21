terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}


provider "digitalocean" {
  token = var.token
}

provider "random" {}

