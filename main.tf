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

resource "digitalocean_project" "costa" {
  name        = "Costa"
  description = "Costa"
  purpose     = "Web Application"
  environment = "Production"
}

resource "digitalocean_ssh_key" "default" {
  name       = "Terraform"
  public_key = var.ssh_public_key
}

variable "ssh_public_key" {
  description = "The public SSH key for DigitalOcean droplet access"
  type        = string
}

resource "digitalocean_droplet" "web" {
  name   = "web-server"
  size   = "s-1vcpu-1gb"  # This is a basic droplet size. Adjust according to your needs.
  image  = "ubuntu-20-04-x64"  # This is the slug for the Ubuntu 20.04 image. You can choose other images.
  region = "nyc1"  # This is the New York City region. Choose the region closest to your users.

  # SSH keys
  ssh_keys = [digitalocean_ssh_key.default.fingerprint] # Ensure you have an SSH key added to your DigitalOcean account and reference its fingerprint here.

  # Networking
  private_networking = true
  ipv6 = true

  # Firewall
  # You can associate a DigitalOcean Cloud Firewall with your droplet for enhanced security
  # firewall_ids = [digitalocean_firewall.your_firewall.id]

  # User data for initial setup
  # Use this to provide a cloud-config script or other user data for configuring the droplet on first boot
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF

  # Specify the project ID
  project = digitalocean_project.example.id
}

