# Declare an AWS provider
# =======================
provider "aws" {
  version = "~> 2.0"
  region  = var.aws_default_region
  profile = var.aws_profile
}
