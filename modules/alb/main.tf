resource "aws_lb" "alb" {
  name               = var.alb_name
  load_balancer_type = "application"

  subnets = var.subnet_ids

  security_groups = [var.sg_id]

  tags = {
    Name = var.alb_name
  }
}

resource "aws_lb_target_group" "apache_tg" {
  name     = "turjo-apache-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group" "nginx_tg" {
  name     = "turjo-nginx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "apache_attach" {
  target_group_arn = aws_lb_target_group.apache_tg.arn
  target_id        = var.apache_instance_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "nginx_attach" {
  target_group_arn = aws_lb_target_group.nginx_tg.arn
  target_id        = var.nginx_instance_id
  port             = 80
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid path"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "apache_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apache_tg.arn
  }

  condition {
    path_pattern {
      values = ["/apache*"]
    }
  }
}

resource "aws_lb_listener_rule" "nginx_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }

  condition {
    path_pattern {
      values = ["/nginx*"]
    }
  }
}