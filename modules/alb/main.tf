resource "aws_lb" "alb" {
  name               = "python-app-lb-tf"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_alb.id]
  subnets            = var.public_subnets_id
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "front_end_rule" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  name     = "tf-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

 health_check {
   path                = "/"
   protocol            = "HTTP"
   matcher             = "200"
   interval            = 60
   timeout             = 30
   healthy_threshold   = 2
   unhealthy_threshold = 3
 }
  depends_on = [
    aws_lb.alb
  ]
}

#Security group for elastic load balancer on created VPC
resource "aws_security_group" "allow_alb" {
  vpc_id = var.vpc_id
  name   = "ALB security group"

  dynamic "ingress" {
    for_each = var.sg_alb_ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB security group"
  }
}
