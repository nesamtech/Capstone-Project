# Capstone-Project
This project showcases how to create and deploy a three tier fault tolerant and reliable Dynamic Wordpress website on AWS. 
Initially, I created an EC2 instance as a web server, hosting WordPress with a local MySQL database. I configured the necessary resources, such as VPCs, security groups, subnets, and route tables, to ensure proper network functionality across two availability zones.

As the project advanced, I shifted the database to an RDS instance for improved scalability, configuring it in a Multi-AZ setup within a private subnet. For the final stage, I added a bastion host, moved the WordPress servers to a private subnet for enhanced security, and introduced a NAT gateway, auto-scaling groups, and an application load balancer to ensure high availability and fault tolerance. This project deepened my knowledge of AWS architecture, automation, and cloud security practices, while also showcasing my ability to manage and optimize cloud infrastructure.
