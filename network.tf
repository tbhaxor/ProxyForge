resource "digitalocean_vpc" "this" {
  name   = "vpc-${var.region}-proxyforge"
  region = var.region
}


resource "digitalocean_loadbalancer" "this" {
  name        = "lb-${var.region}-proxyforge"
  droplet_tag = var.tag-name
  vpc_uuid    = digitalocean_vpc.this.id
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
  name = "fw-proxyforge"
  tags = [var.tag-name]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "all"
    source_load_balancer_uids = [digitalocean_loadbalancer.this.id]
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
  value       = digitalocean_loadbalancer.this.ip
}

