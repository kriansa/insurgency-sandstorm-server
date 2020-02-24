resource "vultr_ssh_key" "main" {
	name = "Main SSH Key"
	ssh_key = var.main_public_ssh_key
}

data "vultr_os" "centos" {
	filter {
		name = "name"
		values = ["CentOS 7 x64"]
	}
}

data "vultr_region" "miami" {
	filter {
		name = "name"
		values = ["Miami"]
	}
}

resource "vultr_startup_script" "install_playbook" {
	name = "Install an ansible playbook"
	script = file("${path.module}/install_ansible.sh")
}

resource "vultr_server" "main" {
	# The 'data' vultr_plan doesn't seem to find plans of high frequency types, so we need to use
	# this static id here.
	# See: `curl 'https://api.vultr.com/v1/plans/list?type=vc2z'`
	# Test plan id: 201
	plan_id = 402
	region_id = data.vultr_region.miami.id
	os_id = data.vultr_os.centos.id
	ssh_key_ids = [vultr_ssh_key.main.id]
	firewall_group_id = vultr_firewall_group.sandstorm.id
	script_id = vultr_startup_script.install_playbook.id
	label = "Sandstorm Server"
	tag = "game"
	hostname = "sandstorm-srv"
	enable_ipv6 = false
	auto_backup = false
	ddos_protection = false
	notify_activate = false

	# Wait then start provisioning
	provisioner "file" {
		source = "${path.root}/../../build/playbook.run"
		destination = "/root/playbook.run"
		connection {
			type = "ssh"
			user = "root"
			host = self.main_ip
		}
	}
}
