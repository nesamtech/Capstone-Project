# create application load balance
resource "aws_lb" "application_load_balancer" {
  name               = "$(var.project_name)-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.aws_security_group.snproject_sg.id]
  ip_address_type    = "ipv4"

  subnet_mapping {
    subnet_id = var.aws_subnet.public_subnet1.id
  }

  subnet_mapping {
    subnet_id = var.aws_subnet.public_subnet2.id
  }

  enable_deletion_protection = false

  tags   = {
    Name = "$(var.project_name)-alb"
  }
}

# create target group
# terraform aws create target group 
resource "aws_lb_target_group" "alb_target_group" {
  name        = "$(var.project_name)-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.my_vpc.id

  health_check {
    healthy_threshold   = 5
    interval            = 20
    matcher             = "200, 301,302"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 5
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn     = aws_lb.application_load_balancer.arn
  port                  = 80
  protocol              = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTPS_301"
    }
  }
}

# create a listener on port 443 with forward action
resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn  = aws_lb.application_load_balancer.arn
  port               = 443
  protocol           = "HTTPS"
  ssl_policy         = "ELBSecurityPolicy-2016-08"
 

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn 
  }
}