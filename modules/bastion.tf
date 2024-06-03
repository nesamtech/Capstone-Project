# Add a Bastion Host
resource "aws_instance" "bastion" {
  ami           = "ami-0bb84b8ffd87024d8" 
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet1.id
  security_groups = [aws_security_group.bastion_sg.name]
  tags = {
    Name = "bastion-host"
  }
}