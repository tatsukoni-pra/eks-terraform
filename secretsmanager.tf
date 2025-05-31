resource "aws_secretsmanager_secret" "argocd" {
  name = "eks-test-cluster/argocd/secret"
}
