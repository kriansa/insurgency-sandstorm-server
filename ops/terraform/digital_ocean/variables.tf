# Require a token
variable "do_token" {
  type = string
  description = "Authentication token for DigitalOcean"
}

variable "admin_ip" {
  type = string
  description = "The IP that should have SSH enabled on the instances"
}

variable "main_public_ssh_key" {
  type = string
  description = "The public SSH key used for using with AWS CodeCommit and EC2"
}
