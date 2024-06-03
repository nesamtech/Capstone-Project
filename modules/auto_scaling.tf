# create a launch template
resource "aws_launch_template" "wordpress_launch_template" {
  name          = var.launch_template_name
  image_id      = "ami-0bb84b8ffd87024d8"
  instance_type = "t2.micro"
  key_name      = "SN_Key"
  description   = "Launch template for asg"

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [aws_security_group.web_security_group.id]
}

# create auto scaling group
resource "aws_autoscaling_group" "wordpress_autoscaling_group" {
  vpc_zone_identifier = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
  desired_capacity    = 2
  max_size            = 2
  min_size            = 1
  name                = "dev-asg"
  health_check_type   = "ELB"

  launch_template {
    name    = aws_launch_template.wordpress_launch_template.name
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "asg-wordpress"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes      = [target_group_arns]
  }
}

# attach auto scaling group to alb target group
resource "aws_autoscaling_attachment" "asg_alb_target_group_attachment" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_autoscaling_group.id
  lb_target_group_arn    = aws_lb_target_group.alb_target_group.arn
}

# create an auto scaling group notification
resource "aws_autoscaling_notification" "wordpress_asg_notifications" {
  group_names = [aws_autoscaling_group.wordpress_autoscaling_group.name] 

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.user_updates.arn
}