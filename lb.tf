######
# ALB
######
resource "aws_lb" "eks_test_alb" {
  name = "eks-test-alb"
  internal = false
  ip_address_type = "ipv4"
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

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.eks_test_alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }
}

######
# Nginx検証用Taget Group
######
resource "aws_lb_target_group" "nginx" {
  name = "tg-nginx"
  target_type = "ip"
  vpc_id = "vpc-025645e04c921bd7c" # tatsukoni-demo-vpc
  port = "80"
  protocol = "HTTP"

  health_check {
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    enabled = "true"
    matcher = "200"
  }

  tags = {
    Name = "eks-test-alb-tg"
  }
}
