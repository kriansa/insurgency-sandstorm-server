variable "admin_ip" {
  type = string
  description = "The IP that should have SSH enabled on the instances"
}

variable "main_public_ssh_key" {
  type = string
  description = "The public SSH key used for authentication"
}

# Require a Vultr token
variable "vultr_api_key" {
  type = string
  description = "Authentication token for Vultr"
}
