# Set AWS variables
# =================
variable aws_default_region {
  type = "string"
}

variable aws_profile {
  type = "string"
}

# Declare an AWS provider
# =======================
provider "aws" {
  version = "~> 1.54.0"
  region = "${var.aws_default_region}"
  profile = "${var.aws_profile}"
}
