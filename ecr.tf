resource "aws_ecr_repository" "k8s_application_nginx" {
  name                 = "k8s-application-nginx"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = false
}
