resource "digitalocean_firewall" "sandstorm" {
  name = "Sandstorm-Server"

  droplet_ids = [digitalocean_droplet.main.id]

  inbound_rule {
    protocol = "tcp"
    port_range = "22"
    source_addresses = var.admin_ips
  }

  inbound_rule {
    protocol = "udp"
    port_range = "27102"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol = "udp"
    port_range = "27131"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "tcp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "udp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
