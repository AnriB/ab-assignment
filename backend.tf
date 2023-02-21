terraform {
  backend "s3" {
    region = "us-east-1"
    key    = "terraformstatefile"
    bucket = "terraformbackendassignment"
  }
}
