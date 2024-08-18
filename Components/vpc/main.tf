# Define a VPC
resource "aws_vpc" "MyVPC" {
  cidr_block = "10.10.0.0/16"
}

# Define a public subnet
resource "aws_subnet" "PublicSubnet" {
  vpc_id     = aws_vpc.MyVPC.id
  cidr_block = "10.10.11.0/24"
  availability_zone = "eu-central-1a"
}

# Define a private subnet
resource "aws_subnet" "PrivateSubnet" {
  vpc_id     = aws_vpc.MyVPC.id
  cidr_block = "10.10.10.0/24"
  availability_zone = "eu-central-1a"
}

# Define a private subnet in AZ eu-central-1a
resource "aws_subnet" "PrivateSubnetA" {
  vpc_id     = aws_vpc.MyVPC.id
  cidr_block = "10.10.21.0/24"
  availability_zone = "eu-central-1b"
  map_public_ip_on_launch = false
}


# Define an Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.MyVPC.id
  tags = {
    Name = "ServerIGW"
  }
}

# Define a Route Table for the public subnet
resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.MyVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

# Associate the Route Table with the public subnet
resource "aws_route_table_association" "publicRTassos" {
  subnet_id      = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.publicRT.id
}

# Security Group for the web server
resource "aws_security_group" "web_server_sg" {
  name        = "web_server_sg"
  description = "Allow inbound HTTP and SSH traffic"
  vpc_id      = aws_vpc.MyVPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

# Security Group for RDS instance
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "RDS security group"
  vpc_id      = aws_vpc.MyVPC.id
  

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]  # Allowing access from the entire VPC
    security_groups = [aws_security_group.web_server_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Subnet Group for RDS Instance
resource "aws_db_subnet_group" "example" {
  name       = "rds-db-subnet-group"
  subnet_ids = [aws_subnet.PrivateSubnet.id,aws_subnet.PrivateSubnetA.id]  # Using the private subnet

  tags = {
    Name = "example-db-subnet-group"
  }
}


# Output private subnet IDs
output "private_subnet_ids" {
  value = [
    aws_subnet.PrivateSubnet.id,
    aws_subnet.PrivateSubnetA.id
  ]
}

