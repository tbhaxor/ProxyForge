variable "token" {
  description = "API token with read/write permissions"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Datacenter region to deploy all the resources"
  type        = string
}

variable "prefix" {
  description = "Resource prefix"
  type        = string
  default     = "pf"
}

variable "slave-count" {
  description = "Number of proxy slaves to deploy"
  type        = number
  default     = 2
}


variable "lb-count" {
  description = "Number of master nodes to setup for load balancer, min 1 is required"
  type        = number
  default     = 1
}

variable "tag-name" {
  description = "Tag name to group slave droplets"
  type        = string
  default     = "proxy-forge-slave"
}

variable "droplet-size" {
  description = "Droplet size to use"
  type = object({
    slave = string
  })
  default = {
    slave = "s-1vcpu-1gb-amd"
  }
}

variable "project" {
  description = "Name of the project to associate all the resources"
  type        = string
  default     = "Proxy Forge"
}

variable "ssh-fingerprint" {
  description = "SSH fingerprint id for droplets to use. If this is ommited, it will send you one-time-password on the email."
  type        = string
  sensitive   = true
  default     = null
}

variable "squid-credentials" {
  description = "Squid proxy HTTP basic authentication credentials"
  type        = object({ username = string, password = string })
  default     = { password = "proxyforge", username = "proxyforge" }
}
