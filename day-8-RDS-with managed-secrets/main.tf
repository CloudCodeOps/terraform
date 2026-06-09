#vpc, subnets and security group creation   

resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "name" {
  vpc_id     = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "name2" {
  vpc_id     = aws_vpc.name.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false
}

resource "aws_security_group" "name" {
  name        = "db-security-group"
  description = "Allow MySQL traffic"
  vpc_id      = aws_vpc.name.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.name.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]   
    }
}

#db subnet group and rds instance creation  

resource "aws_db_subnet_group" "name" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.name.id, aws_subnet.name2.id]
}

#primary database instance

resource "aws_db_instance" "name" {
  identifier              = "mydbinstance"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_name                 = "mydatabase"
  username                = "admin"
  #password                = var.db_password

  manage_master_user_password = true  # enable managed secrets

  backup_retention_period = 1             #required for replicas
  db_subnet_group_name    = aws_db_subnet_group.name.name
  vpc_security_group_ids  = [aws_security_group.name.id]
  skip_final_snapshot     = true
}




#redis cluster

resource "aws_elasticache_subnet_group" "name" {
  name       = "cache-subnet-group"
  subnet_ids = [aws_subnet.name.id, aws_subnet.name2.id]
}

resource "aws_elasticache_cluster" "name" {
  cluster_id           = "mycachecluster"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  subnet_group_name    = aws_elasticache_subnet_group.name.name
  security_group_ids   = [aws_security_group.name2.id]
}

resource "aws_security_group" "name2" {
  name        = "cache-security-group"
  description = "Allow Redis traffic"
  vpc_id      = aws_vpc.name.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.name.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]   
  }
}