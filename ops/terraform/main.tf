module "sandstorm_server" {
  source = "./vultr"

  # Pass down the variables
  vultr_api_key = var.vultr_api_key
  admin_ip = var.admin_ip
  main_public_ssh_key = var.main_public_ssh_key
}

output "instance_ip" {
  value = module.sandstorm_server.node_ip
}

terraform {
  required_version = ">= 0.12"
}
