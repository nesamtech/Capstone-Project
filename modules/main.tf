# Create VPC where instance will be launched into
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Create an Internet Gateway and attach it to the vpc
resource "aws_internet_gateway" "project_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.project_name}-IGW"
  }
}

# Use data source to get all availability zones in the region
data "aws_availability_zones" "available_zones" {}

#  Create Public Subnets for the Instance in az1
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Sn_Public_az1"
  }
}

# Create  Private Subnets for the Instance in az1 
resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_az1_cidr
  availability_zone = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "Sn_Private_az1"
  }
}

# Create  Public Subnets for the Instance in az2 
resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "Sn_Public_az2"
  }
}

# Create  Private Subnets for the Instance in az2
resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "Sn_Private_az2"
  }
}

# Create route table and add Public route to it
resource "aws_route_table" "SN_public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_igw.id
  }
  tags = {
    Name = "Sn_Pub_Route_Table"
  }
}

# Create route table and add Private route to it
resource "aws_route_table" "SN_private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_igw.id
  }
  tags = {
    Name = "Sn_Pri_Route_Table"
  }
}

# Associate Public Subnet in az1 to Public Route Table 
resource "aws_route_table_association" "public_subnet1_association" {
  subnet_id      = var.public_subnet1.id
  route_table_id = aws_route_table.SN_public_route_table.id
  depends_on     = [aws_route_table.SN_public_route_table, aws_subnet.public_subnet1]
}

# Associate Public Subnet in az2 to Public Route Table 
resource "aws_route_table_association" "public_subnet2_association" {
  subnet_id      = var.public_subnet2.id
  route_table_id = aws_route_table.SN_public_route_table.id
  depends_on     = [aws_route_table.SN_public_route_table, aws_subnet.public_subnet2]
}

# Associate Private app Subnet in az1 to Private Route Table 
resource "aws_route_table_association" "private_subnet1_association" {
  subnet_id      = var.private_subnet1.id
  route_table_id = aws_route_table.SN_private_route_table.id
  depends_on     = [aws_route_table.SN_private_route_table, aws_subnet.private_subnet1]
}

# Associate Private app Subnet in az2 to Private Route Table 
resource "aws_route_table_association" "private_subnet2_association" {
  subnet_id      = var.private_subnet2.id
  route_table_id = aws_route_table.SN_private_route_table.id
  depends_on     = [aws_route_table.SN_private_route_table, aws_subnet.private_subnet2]
}

# Create a private data subnet in az1 (for rds)
resource "aws_subnet" "private_rds_subnet_az1" {
  vpc_id                  =  aws_vpc.my_vpc.id
  cidr_block              =  var.private_rds_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch =  false

  tags = {
    Name = "Private rds subnet az1"
  }
}

# Create a private data subnet in az2 (for rds)
resource "aws_subnet" "private_rds_subnet_az2" {
  vpc_id                  =  aws_vpc.my_vpc.id
  cidr_block              =  var.private_rds_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch =  false

  tags = {
    Name = "Private rds subnet az2"
  }
}