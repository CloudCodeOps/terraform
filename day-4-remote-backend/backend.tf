terraform {
  backend "s3" {
    bucket = "terraform-backend-bkt-s3"
    key    = "terraform.tfstate"
    region = "us-east-1"
    
  }
}