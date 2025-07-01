# VPC principal
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main_vpc"
  }
}

# Subnets públicas (duas AZs)
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.20.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet2"
  }
}

# Subnets privadas (duas AZs)
resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.30.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private_subnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.40.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private_subnet2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main-igw"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associar route table às subnets públicas
resource "aws_route_table_association" "public_subnet1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public.id
}

# Security Group: SSH, HTTP e PostgreSQL (5432)
resource "aws_security_group" "allow_web_ssh" {
  name        = "web_ssh_sg"
  description = "Allow SSH, HTTP, and PostgreSQL"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_ssh_sg"
  }
}

# EC2 instance
resource "aws_instance" "web" {
  ami                    = "ami-0a7d80731ae1b2435"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.allow_web_ssh.id]
  key_name               = var.key_name

  tags = {
    Name = "Microservice-Host"
  }
}

# DB Subnet Group com duas AZs
resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "postgres-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet1.id,
    aws_subnet.private_subnet2.id
  ]

  tags = {
    Name = "postgres-subnet-group"
  }
}

# RDS PostgreSQL
resource "aws_db_instance" "postgres" {
  identifier             = "terraform-rds-postgres"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "14"
  instance_class         = "db.t3.micro"
  db_name                = "terraformDatabase"
  username               = "LuizNazareth"
  password               = "Lg160103*"
  skip_final_snapshot    = true
  publicly_accessible    = true
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.postgres_subnet_group.name
  vpc_security_group_ids = [aws_security_group.allow_web_ssh.id]

  tags = {
    Name = "Postgres-DB"
  }
}

##JENKINS INSTANCE

resource "aws_instance" "jenkins" {
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.allow_web_ssh.id]
  key_name               = var.key_name

  tags = {
    Name = "Microservice-Host-Jenkins"
  }
}
