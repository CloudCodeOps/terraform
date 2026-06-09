#instance creation

resource "aws_instance" "name" {
    ami           = "ami-00e801948462f718a"
    instance_type = "t3.micro"
    availability_zone = "us-east-1a"
    subnet_id = aws_subnet.name.id
    vpc_security_group_ids = [aws_security_group.sg.id]
        tags = {
            Name = "depends-on-block-instance"
        }
}

#security group creation
resource "aws_security_group" "sg" {
    name        = "depends-on-block-sg"
    description = "allow SSH traffic"
    vpc_id      = aws_vpc.vpc.id
  
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#s3 bucket creation

resource "aws_s3_bucket" "name" {
    bucket = "depends-on-block-bucket-example"
    acl    = "private"
    tags = {
        Name = "depends-on-block-bucket"
    }
}

#vpc creation 
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "depends-on-block-vpc"
    }
}

resource "aws_subnet" "name" {
      vpc_id     = aws_vpc.vpc.id
    cidr_block   = "10.0.0.0/26"
    availability_zone = "us-east-1a"
    tags = {    
        Name = "depends-on-block-subnet"
    }   
}