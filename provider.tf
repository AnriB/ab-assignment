provider "aws" {
  profile = var.profile
  region  = var.region
  alias   = "default-region"
}
