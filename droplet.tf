locals {
  slave_urns = [
    for instance in digitalocean_droplet.slave :
    instance.urn
  ]
}

resource "random_integer" "slave-suffix" {
  min   = 10000
  max   = 99999
  seed  = count.index
  count = var.slave-count
}

resource "digitalocean_droplet" "slave" {
  name          = "${var.prefix}-${var.region}-proxy-slave-${random_integer.slave-suffix[count.index].result}"
  tags          = [var.tag-name]
  ssh_keys      = var.ssh-fingerprint != null ? [var.ssh-fingerprint] : []
  vpc_uuid      = digitalocean_vpc.main.id
  region        = var.region
  count         = var.slave-count
  monitoring    = true
  droplet_agent = true
  image         = "debian-12-x64"
  size          = var.droplet-size.slave
  user_data     = templatefile("user-data.tftpl", { loadbalancer-ip = digitalocean_loadbalancer.lb.ip, squid-credentials = var.squid-credentials })
}
