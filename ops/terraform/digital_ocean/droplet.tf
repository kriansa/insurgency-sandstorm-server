# Container for this project
resource "digitalocean_project" "sandstorm" {
  name = "sandstorm-server"
  description = "My private Insurgency: Sandstorm game server"
  purpose = "Game Server"
  environment = "Production"

  resources = [digitalocean_droplet.main.urn]
}

# Create a new SSH key
resource "digitalocean_ssh_key" "default" {
  name = "Default Key"
  public_key = var.main_public_ssh_key
}

# Create a new Droplet using the SSH key
resource "digitalocean_droplet" "main" {
  image = "centos-7-x64"
  name = "sandstorm-server"
  region = "nyc3"

  # CPU-Optimized instance
  # size = "c-2-4gib"

  # Standard Instance
  size = "s-1vcpu-2gb"

  ssh_keys = [digitalocean_ssh_key.default.fingerprint]

  # Wait then start provisioning
  provisioner local-exec {
    command = "../bin/provision root@${self.ipv4_address}"
  }
}
