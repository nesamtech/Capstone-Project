# Create the subnet group for the RDS instance
resource "aws_db_subnet_group" "rds_subnet" {
  name        = "${var.project_name}-rds-subnets"
  subnet_ids  = [var.private_rds_subnet_az1.id, var.private_rds_subnet_az2.id]
  description = "Subnet for RDS database instance"

  tags = {
    Name = "${var.project_name}-rds-subnets"
  }
}

# Mysql RDS Instances
resource "aws_rds_instance" "database_instance" {
  allocated_storage         = "20"
  engine                    = "mysql"
  instance_class            = "db.t3.micro"
  parameter_group_name      = "dafault.mysql8.0"
  database_name             = "sam_wordpress_db"
  master_username           = "samntochukwu"
  master_password           = "wpadminpassword"
  db_subnet_group_name      = aws_db_subnet_group.rds_subnet.name
  vpc_security_group_ids    = [aws_security_group.rds_security_group.id]
  final_snapshot_identifier = "my-final-snapshot"
  skip_final_snapshot       = true
  multi_az                  = true
  publicly_accessible       = false
  availability_zone         = [data.aws_availability_zones.available_zones.names[0], data.aws_availability_zones.available_zones.names[1]]

  tags = {
    Name = "RDS-Instance-db"
  }
}