#creation of VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my_vpc"
      }
}

#creation of subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true    #to assign public IP to instances launched in this subnet
    tags = {
        Name = "public_subnet"
        }
}

resource "aws_subnet" "main2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false   #to not assign public IP to instances launched in this subnet
    tags = {
        Name = "private_subnet"
     
          }
}

#creation of internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
    tags = {
        Name = "my_igw"
  }
}

#creation of route table and route
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
    tags = {
        Name = "public_rt"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

#association of route table with subnet
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}


#creation of NAT gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.main.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]

}

# Elastic IP for NAT gateway
resource "aws_eip" "main" {
 #vpc = true
  tags = {
    Name = "nat_eip"
  }
}

#creation route table and route for private subnet
resource "aws_route_table" "main2" {
  vpc_id = aws_vpc.main.id
    tags = {
        Name = "private_rt"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
}

#association of route table with private subnet
resource "aws_route_table_association" "main2" {
  subnet_id      = aws_subnet.main2.id
  route_table_id = aws_route_table.main2.id
}

#creation of security group
resource "aws_security_group" "main" {
  name        = "my_sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.main.id

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

#creation of Instance in public subnet
resource "aws_instance" "main" {
  ami           =  var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.main.id]
    tags = {
        Name = "public_instance"
  }
}

#creation of Instance in private subnet
resource "aws_instance" "main2" {
  ami           =  var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main2.id
  vpc_security_group_ids = [aws_security_group.main.id]
    tags = {
        Name = "private_instance"
  }
}
