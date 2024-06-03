resource "aws_instance" "Wordpress-Instance" {
  ami                         = "ami-0bb84b8ffd87024d8"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet1.id
  vpc_security_group_ids      = [aws_security_group.snproject_sg.id]
  key_name                    = "SN_Key"
  count                       = 1
  associate_public_ip_address = true

  # EC2 instance with user data

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo yum install -y mariadb-server php php-mysqlnd unzip

              sudo systemctl start httpd
              sudo systemctl enable httpd

              sudo systemctl start mariadb
              sudo systemctl enable mariadb

              cd /var/www/html
              sudo wget http://wordpress.org/latest.tar.gz
              sudo tar -zxvf latest.tar.gz 
              sudo cp -rvf wordpress/* . 
              sudo rm -R wordpress 
              sudo rm latest.tar.gz

              sudo mysqladmin -u root password $DBRootPassword

              sudo cp ./wp-config-sample.php ./wp-config.php
              sudo sed -i "s/'database_name_here'/'sam_wordpress_db'/g" wp-config.php 
              sudo sed -i "s/'username_here'/'samntochukwu'/g" wp-config.php 
              sudo sed -i "s/'password_here'/'wpadminpassword'/g" wp-config.php

              sudo usermod -a -G apache ec2-user 
              sudo chown -R ec2-user:apache /var/www 
              sudo chmod 2775 /var/www 
              sudo find /var/www -type d -exec chmod 2775 {} \; 
              sudo find /var/www -type f -exec chmod 0664 {} \; 

              echo "CREATE DATABASE sam_wordpress_db;" >> /tmp/db.setup 
              echo "CREATE USER 'samntochukwu'@'localhost' IDENTIFIED BY 'wpadminpassword.';" >> /tmp/db.setup 
              echo "GRANT ALL ON sam_wordpress_db.* TO 'samntochukwu'@'localhost';" >> /tmp/db.setup 
              echo "FLUSH PRIVILEGES;" >> /tmp/db.setup 
              sudo mysql -u root --password=$DBRootPassword < /tmp/db.setup
              sudo rm /tmp/db.setup

              # Configure WordPress to use RDS database
              cat << WP_EOF | sudo tee -a /var/www/html/wp-config.php
              define('DB_NAME', 'sam_wordpress_db');
              define('DB_USER', 'samntochukwu');
              define('DB_PASSWORD', 'wpadminpassword');
              define('DB_HOST', '${var.rds_endpoint}');
              define('DB_CHARSET', 'utf8');
              define('DB_COLLATE', '');
              WP_EOF

              # Restart Apache
              sudo systemctl restart httpd
              EOF
                tags = {
                  Name = "Wordpress-Instance"
                }
}