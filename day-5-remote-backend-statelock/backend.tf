terraform {
  backend "s3" {
    bucket = "terraform-backend-bkt-s3"
    key    = "terraform.tfstate"
    use_lockfile = true #s3 native lockeing process to prevent concurrent stae modifications
    region = "us-east-1"
    
  }
}