

resource "aws_instance" "name" {
    ami           = "ami-00e801948462f718a"
    instance_type = "t3.micro"
    tags = {
        Name = "ec2"
    }
  
}

resource "aws_s3_bucket" "name" {
    bucket = "regscvtyedufyg"
   
  
}

resource "aws_s3_bucket_versioning" "name" {
    bucket = aws_s3_bucket.name.id
    versioning_configuration {
        status = "Suspended"
    }
}