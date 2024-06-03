# To create Security Group for the VPC
resource "aws_security_group" "snproject_sg" {
  name        = "snproject_sg"
  description = "Allow SSH & HTTP inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  # Inbound rules for HTTP
  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound rules for HTTPS
  ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # Inbound rules for SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "vpc security group"
  }
}

# create a security group for the application
resource "aws_security_group" "web_security_group" {
  name        = "web_security_group"
  description = "Allow http & https inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.snproject_sg.id]
  }

  ingress {
    description = "allow https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.snproject_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2 security group"
  }
}

# Security group for RDS
resource "aws_security_group" "rds_security_group" {
  name        = "allow_ec2_mysql"
  description = "Allow EC2 to mysql traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "allow ec2 to mysql"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS security groups"
  }
}

# Seurity group for Bastion Host
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.my_vpc.id

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

  tags = {
    Name = "Bastion-sg"
  }
}