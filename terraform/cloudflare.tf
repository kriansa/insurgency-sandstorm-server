# Set CF variables
# ================
variable cloudflare_email {
  type = "string"
}

variable cloudflare_token {
  type = "string"
}

# Configure the Cloudflare provider
# =================================
provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}
