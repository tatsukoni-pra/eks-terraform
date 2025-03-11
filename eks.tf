######
# EKS Cluster
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster
######
resource "aws_eks_cluster" "eks_test_cluster" {
  name     = "eks-test-cluster"
  role_arn = aws_iam_role.eks_test_cluster_role.arn
  # version = "1.32" 指定しない場合はリソース作成時に利用可能な最新バージョンが使用される

  vpc_config {
    subnet_ids = [
      "subnet-0fc6ea4c93a919961", # tatsukoni-demo-subnet-private-1a
      "subnet-0cdf0dfdbaff1ff9e"  #tatsukoni-demo-subnet-private-1c
    ]
    endpoint_private_access = true
    endpoint_public_access  = true
  }
}
