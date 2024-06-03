variable "region" {}
variable "project_name" {}
variable "vpc_cidr" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "private_subnet_az1_cidr" {}
variable "private_subnet_az2_cidr" {}
variable "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  type        = string
  default     = "rds-instance.cbaswscgclhw.us-east-1.rds.amazonaws.com" # You can use a placeholder or empty string here
}
variable "private_rds_subnet_az1_cidr" {}
variable "private_rds_subnet_az2_cidr" {}
variable "public_subnet1_id" {}
variable "public_subnet2_id" {}
variable "internet_gateway" {}
variable "private_subnet1_id" {}
variable "private_subnet2_id" {}
variable "private_rds_subnet_az1_id" {}
variable "private_rds_subnet_az2_id" {}
variable "launch_template_name" {}