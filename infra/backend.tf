terraform {
  backend "s3" {
    bucket  = "superstore-dataset"
    key     = "terraform/state/terraform.tfstate"
    region  = "us-east-1"
    profile = "daverse-dev"
  }
}
