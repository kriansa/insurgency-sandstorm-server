# Let's use Digital Ocean
module "digital_ocean" {
  source = "./digital_ocean"

  # Pass down the variables
  do_token = var.do_token
  admin_ips = var.admin_ips
  main_public_ssh_key = var.main_public_ssh_key
}

terraform {
  required_version = ">= 0.12"
}
