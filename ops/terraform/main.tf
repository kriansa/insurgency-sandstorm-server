module "sandstorm_server" {
  source = "./vultr"

  # Pass down the variables
  vultr_api_key = var.vultr_api_key
  admin_ip = var.admin_ip
  main_public_ssh_key = var.main_public_ssh_key
}

terraform {
  required_version = ">= 0.12"
}
