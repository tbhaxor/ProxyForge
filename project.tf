resource "digitalocean_project" "this" {
  name      = var.project
  resources = concat([digitalocean_loadbalancer.this.urn], digitalocean_droplet.slave[*].urn)
}
