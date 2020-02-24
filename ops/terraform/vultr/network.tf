resource "vultr_firewall_group" "sandstorm" {
	description = "Sandstorm server firewall rules"
}

resource "vultr_firewall_rule" "allow_ssh_from_admin" {
	firewall_group_id = vultr_firewall_group.sandstorm.id
	protocol = "tcp"
	# In the future, accept all admin IPs if this is a list
	network = var.admin_ip
	from_port = "22"
}

resource "vultr_firewall_rule" "allow_game_port" {
	firewall_group_id = vultr_firewall_group.sandstorm.id
	protocol = "udp"
	network = "0.0.0.0/0"
	from_port = "27102"
}

resource "vultr_firewall_rule" "allow_game_query_port" {
	firewall_group_id = vultr_firewall_group.sandstorm.id
	protocol = "udp"
	network = "0.0.0.0/0"
	from_port = "27131"
}
