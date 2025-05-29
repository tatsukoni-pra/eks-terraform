data "aws_acm_certificate" "cert" {
  domain      = "awsometatsukoni.com"
  most_recent = true
}
