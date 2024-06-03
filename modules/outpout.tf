
output "region" {
  value = var.region
}

output "project_name" {
  value = var.project_name
}

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "public_subnet_az1_id" {
  value = aws_subnet.public_subnet1.id
}

output "public_subnet_az2_id" {
  value = aws_subnet.public_subnet2.id
}

output "private_subnet_az1_id" {
  value = aws_subnet.private_subnet1.id
}

output "private_subnet_az2_id" {
  value = aws_subnet.private_subnet2.id
}

output "private_data_subnet_az1_id" {
  value = aws_subnet.private_rds_subnet_az1.id
}

output "private_data_subnet_az2_id" {
  value = aws_subnet.private_rds_subnet_az2.id
}

output "internet_gateway" {
  value = aws_internet_gateway.project_igw
}

output "snproject_sg_id" {
  value = aws_security_group.snproject_sg.id
}

output "web_security_group_id" {
  value = aws_security_group.web_security_group.id
}

output "aws_db_subnet_group" {
  value = aws_db_subnet_group.rds_subnet.name
}