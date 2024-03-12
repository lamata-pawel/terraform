terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}


resource "digitalocean_ssh_key" "default" {
  name       = "Terraform"
  public_key = var.ssh_public_key
}

variable "ssh_public_key" {
  description = "The public SSH key for DigitalOcean droplet access"
  type        = string
}

resource "digitalocean_project" "costa" {
  name        = "Costa"
  description = "Costa"
  purpose     = "Web Application"
  environment = "Development"
}

resource "digitalocean_project_resources" "web_project" {
  project = digitalocean_project.costa.id

  resources = [
    digitalocean_droplet.client1.urn,
  ]
}



