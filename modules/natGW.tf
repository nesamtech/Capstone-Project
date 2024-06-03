# allocate elastic IP, it will be used for the Nat Gateway in the public az
resource "aws_eip" "eip_for_nat_gateway_public1" {
  # vpc    = true

  tags    = {
    Name  = "Nat gateway public1 eip"
  }
}

# allocate elastic IP, it will be used for the Nat Gateway in the private az
resource "aws_eip" "eip_for_nat_gateway_public2" {
  # vpc     = true
  
  tags  = {
    Name = "Nat gateway public2 eip"
  }
}

# Create a NAT Gateway for the public subnet(s) to access the internet in az1
resource "aws_nat_gateway" "sn_nat_az1" {
  allocation_id = aws_eip.eip_for_nat_gateway_public1.id
  subnet_id     = var.public_subnet1.id

  tags = {
    Name = "Public-nat-gw-az1"
  }
  # to ensure proper ordering, it is recommended to add an explicit dependency
  # on the internet gateway for the vpc.
  depends_on = [var.internet_gateway]
}

# Create a NAT Gateway for the public subnet(s) to access the internet in az2
resource "aws_nat_gateway" "sn_nat_az2" {
  allocation_id = aws_eip.eip_for_nat_gateway_public2.id
  subnet_id     = var.public_subnet2.id

  tags = {
    Name = "Public-nat-gw-az2"
  }
  # to ensure proper ordering, it is recommended to add an explicit dependency
  # on the internet gateway for the vpc.
  depends_on = [var.internet_gateway]
}

# create private route table az1 and add route through nat gateway az1
resource "aws_route_table" "private_route_table_az1" {
  vpc_id            = aws_vpc.my_vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.sn_nat_az1.id 
  }

  tags   = {
    Name = "Private NAT_RT az1"
  }
}

# associate private app subnet az1 with private route table az1
resource "aws_route_table_association" "private_app_subnet_az1_route_table_az1_association" {
  subnet_id         = var.private_subnet1.id 
  route_table_id    = aws_nat_gateway.sn_nat_az1.id  
}

# associate private app subnet az2 with private route table az2
resource "aws_route_table_association" "private_app_subnet_az2_route_table_az2_association" {
  subnet_id         = var.private_subnet2.id
  route_table_id    = aws_nat_gateway.sn_nat_az2.id   
}

# create private route table az2 and add route through nat gateway az2
resource "aws_route_table" "private_route_table_az2" {
  vpc_id            = aws_vpc.my_vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.sn_nat_az2.id
  }

  tags   = {
    Name = "Private NAT_RT az2"
  }
}

# associate private data subnet az1 with private route table az1 (for rds)
resource "aws_route_table_association" "private_data_subnet_az1_route_table_az1_association" {
  subnet_id         = var.private_data_subnet_az1.id
  route_table_id    = aws_nat_gateway.sn_nat_az1.id  
}

# associate private data subnet az2 with private route table az2 (for rds)
resource "aws_route_table_association" "private_data_subnet_az2_route_table_az2_association" {
  subnet_id         = var.private_data_subnet_az2.id 
  route_table_id    = aws_nat_gateway.sn_nat_az2.id 
}