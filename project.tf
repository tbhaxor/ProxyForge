resource "digitalocean_project" "pf-project" {
  name       = var.project
  resources  = [digitalocean_loadbalancer.lb.urn]
  depends_on = [digitalocean_droplet.slave, digitalocean_loadbalancer.lb]
}

resource "digitalocean_project_resources" "pf-project-move-resources" {
  project    = digitalocean_project.pf-project.id
  resources  = concat([digitalocean_loadbalancer.lb.urn], local.slave_urns)
  depends_on = [digitalocean_droplet.slave]
}
