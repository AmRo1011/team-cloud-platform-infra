###############################################
# VPC
###############################################

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "learning-platform-vpc"
    Environment = var.env
  }
}
###############################################
# Public Subnets
###############################################

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-1"
    Environment = var.env
  }
}
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-2"
    Environment = var.env
  }
}
###############################################
# Private Subnets
###############################################

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name        = "private-subnet-1"
    Environment = var.env
  }
}
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name        = "private-subnet-2"
    Environment = var.env
  }
}
###############################################
# Database Subnets (RDS)
###############################################

resource "aws_subnet" "db_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name        = "db-subnet-1"
    Environment = var.env
  }
}
resource "aws_subnet" "db_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name        = "db-subnet-2"
    Environment = var.env
  }
}
###############################################
# Kafka Subnets
###############################################

resource "aws_subnet" "kafka_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.30.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name        = "kafka-subnet-1"
    Environment = var.env
  }
}
resource "aws_subnet" "kafka_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.31.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name        = "kafka-subnet-2"
    Environment = var.env
  }
}
###############################################
# Internet Gateway
###############################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "learning-platform-igw"
    Environment = var.env
  }
}
###############################################
# Public Route Table
###############################################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "public-route-table"
    Environment = var.env
  }
}
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
resource "aws_route_table_association" "public_1_assoc" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2_assoc" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}
###############################################
# NAT Gateways — Elastic IPs
###############################################

resource "aws_eip" "nat_eip_1" {
  vpc = true

  tags = {
    Name        = "nat-eip-1"
    Environment = var.env
  }
}

resource "aws_eip" "nat_eip_2" {
  vpc = true

  tags = {
    Name        = "nat-eip-2"
    Environment = var.env
  }
}
resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name        = "nat-gateway-1"
    Environment = var.env
  }
}
resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public_2.id

  tags = {
    Name        = "nat-gateway-2"
    Environment = var.env
  }
}
###############################################
# Private Route Tables
###############################################

resource "aws_route_table" "private_rt_1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "private-route-table-1"
    Environment = var.env
  }
}
resource "aws_route_table" "private_rt_2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "private-route-table-2"
    Environment = var.env
  }
}
resource "aws_route" "private_1_nat_route" {
  route_table_id         = aws_route_table.private_rt_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_1.id
}
resource "aws_route" "private_2_nat_route" {
  route_table_id         = aws_route_table.private_rt_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_2.id
}
resource "aws_route_table_association" "private_1_assoc" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt_1.id
}

resource "aws_route_table_association" "private_2_assoc" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt_2.id
}
###############################################
# Database Route Table
###############################################

resource "aws_route_table" "db_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "db-route-table"
    Environment = var.env
  }
}
resource "aws_route_table_association" "db_1_assoc" {
  subnet_id      = aws_subnet.db_1.id
  route_table_id = aws_route_table.db_rt.id
}

resource "aws_route_table_association" "db_2_assoc" {
  subnet_id      = aws_subnet.db_2.id
  route_table_id = aws_route_table.db_rt.id
}
###############################################
# Kafka Route Table
###############################################

resource "aws_route_table" "kafka_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "kafka-route-table"
    Environment = var.env
  }
}
resource "aws_route" "kafka_nat_route" {
  route_table_id         = aws_route_table.kafka_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_1.id
}
resource "aws_route_table_association" "kafka_1_assoc" {
  subnet_id      = aws_subnet.kafka_1.id
  route_table_id = aws_route_table.kafka_rt.id
}

resource "aws_route_table_association" "kafka_2_assoc" {
  subnet_id      = aws_subnet.kafka_2.id
  route_table_id = aws_route_table.kafka_rt.id
}
