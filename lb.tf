######
# ALB
######
resource "aws_lb" "eks_test_alb" {
  name               = "eks-test-alb"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"

  security_groups = [
    "sg-09404dd1f6df8c55a"
  ]
  subnets = [
    "subnet-0043c72cfb2b9bc77", # tatsukoni-demo-subnet-public-1c
    "subnet-0b59531acff265d5d"  # tatsukoni-demo-subnet-public-1a
  ]

  tags = {
    Name = "eks-test-alb"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.eks_test_alb.arn
  certificate_arn   = data.aws_acm_certificate.cert.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
    }
  }
}

######
# ArgoCD
######
resource "aws_lb_listener_rule" "argocd" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.argocd.arn
  }

  condition {
    host_header {
      values = ["argocd-demo.awsometatsukoni.com"]
    }
  }
}

resource "aws_lb_target_group" "argocd" {
  name        = "tg-argocd"
  target_type = "ip"
  vpc_id      = "vpc-025645e04c921bd7c" # tatsukoni-demo-vpc
  port        = "80"
  protocol    = "HTTP"

  health_check {
    path     = "/healthz"
    port     = "traffic-port"
    protocol = "HTTP"
    enabled  = "true"
    matcher  = "200"
  }

  tags = {
    Name = "tg-argocd"
  }
}

######
# k8s Application
resource "aws_lb_listener_rule" "k8s_application" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8s_application.arn
  }

  condition {
    host_header {
      values = ["k8s-application.awsometatsukoni.com"]
    }
  }
}

resource "aws_lb_target_group" "k8s_application" {
  name        = "tg-k8s-application"
  target_type = "ip"
  vpc_id      = "vpc-025645e04c921bd7c" # tatsukoni-demo-vpc
  port        = "80"
  protocol    = "HTTP"

  health_check {
    path     = "/"
    port     = "traffic-port"
    protocol = "HTTP"
    enabled  = "true"
    matcher  = "200"
  }

  tags = {
    Name = "tg-k8s-application"
  }
}
