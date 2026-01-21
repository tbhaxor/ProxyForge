resource "random_string" "vm-suffix" {
  count   = var.slave-count
  length  = 7
  upper   = false
  special = false
}

resource "digitalocean_droplet" "slave" {
  name          = "vm-${var.region}-proxyforge-slave-${random_string.vm-suffix[count.index].result}"
  tags          = [var.tag-name]
  ssh_keys      = var.ssh-fingerprint != null ? [var.ssh-fingerprint] : []
  vpc_uuid      = digitalocean_vpc.this.id
  region        = var.region
  count         = var.slave-count
  monitoring    = true
  droplet_agent = true
  image         = "debian-12-x64"
  size          = var.droplet-size.slave
  user_data = templatefile("user-data.tftpl", {
    loadbalancer-ip   = digitalocean_loadbalancer.this.ip
    squid-credentials = var.squid-credentials
  })

  lifecycle {
    create_before_destroy = true
  }
}
