terraform {
  backend "s3" {
    bucket = "sjf-terraform-us-east-1"
    key    = "setheryops.tfstate"
    region = "us-east-1"
  }
}
