terraform {
  backend "s3" {
    bucket       = "group8-dev-tfstate-bucket"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
