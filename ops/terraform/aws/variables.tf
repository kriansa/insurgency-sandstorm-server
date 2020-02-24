# Set AWS variables
# =================
variable "aws_default_region" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "admin_ip" {
  type        = string
  description = "The IP that should have SSH enabled on the instances"
}

variable "main_public_ssh_key" {
  type        = string
  description = "The public SSH key used for using with AWS CodeCommit and EC2"
}
