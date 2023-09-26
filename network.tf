resource "digitalocean_vpc" "main" {
  name   = "${var.prefix}-${var.region}-vpc"
  region = var.region
}


resource "digitalocean_loadbalancer" "lb" {
  name        = "${var.prefix}-lb"
  droplet_tag = var.tag-name
  vpc_uuid    = digitalocean_vpc.main.id
  region      = var.region
  size_unit   = var.lb-count

  forwarding_rule {
    entry_port      = 80
    entry_protocol  = "tcp"
    target_port     = 3128
    target_protocol = "tcp"
  }

  healthcheck {
    protocol = "tcp"
    port     = 3128
  }
}

resource "digitalocean_firewall" "slave-lb-firewall" {
  name = "${var.prefix}-fw"
  tags = [var.tag-name]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "all"
    source_load_balancer_uids = [digitalocean_loadbalancer.lb.id]
  }

  outbound_rule {
    destination_addresses = ["0.0.0.0/0", "::/0"]
    protocol              = "tcp"
    port_range            = "all"
  }

  outbound_rule {
    destination_addresses = ["0.0.0.0/0", "::/0"]
    protocol              = "udp"
    port_range            = "all"
  }

  outbound_rule {
    destination_addresses = ["0.0.0.0/0", "::/0"]
    protocol              = "icmp"
  }
}

output "lb-ip" {
  description = "IP Address of the load balancer"
  value       = digitalocean_loadbalancer.lb.ip
}

