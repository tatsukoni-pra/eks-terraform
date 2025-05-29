data "aws_route53_zone" "awsometatsukoni" {
  name = "awsometatsukoni.com"
}

resource "aws_route53_record" "argocd" {
  zone_id = data.aws_route53_zone.awsometatsukoni.zone_id
  name    = "argocd-demo"
  type    = "A"
  alias {
    name                   = aws_lb.eks_test_alb.dns_name
    zone_id                = aws_lb.eks_test_alb.zone_id
    evaluate_target_health = false
  }
  depends_on = [aws_lb.eks_test_alb]
}
