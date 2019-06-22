# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
  version = "~> 1.4"
}
