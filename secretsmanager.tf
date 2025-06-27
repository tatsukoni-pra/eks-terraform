resource "aws_secretsmanager_secret" "argocd" {
  name = "eks-test-cluster/argocd/secret"
}

resource "aws_secretsmanager_secret" "k8s_application" {
  name = "eks-test-cluster/k8s-application/secret"
}
