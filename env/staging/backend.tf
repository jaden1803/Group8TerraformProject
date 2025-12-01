 terraform {
  backend "s3" {
    bucket       = "group8-staging-tfstate-bucket"
    key          = "staging/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
