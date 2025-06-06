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
      "subnet-0cdf0dfdbaff1ff9e"  # tatsukoni-demo-subnet-private-1c
    ]
    endpoint_private_access = true
    endpoint_public_access  = true
  }
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_test_cluster.name
  node_group_name = "eks-test-ng"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids = [
    "subnet-0fc6ea4c93a919961", # tatsukoni-demo-subnet-private-1a
    "subnet-0cdf0dfdbaff1ff9e"  # tatsukoni-demo-subnet-private-1c
  ]
  capacity_type = "ON_DEMAND"
  launch_template {
    id      = aws_launch_template.node_group.id
    version = aws_launch_template.node_group.latest_version
  }

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  instance_types = [
    "t3.medium"
  ]
  # https://aws.amazon.com/jp/bottlerocket/?amazon-bottlerocket-whats-new.sort-by=item.additionalFields.postDateTime&amazon-bottlerocket-whats-new.sort-order=desc
  ami_type = "BOTTLEROCKET_x86_64"

  update_config {
    # Desired max number of unavailable worker nodes during node group update
    max_unavailable = 1
  }
}

resource "aws_eks_node_group" "node_group_arm" {
  cluster_name    = aws_eks_cluster.eks_test_cluster.name
  node_group_name = "eks-test-ng-arm"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids = [
    "subnet-0fc6ea4c93a919961", # tatsukoni-demo-subnet-private-1a
    "subnet-0cdf0dfdbaff1ff9e"  # tatsukoni-demo-subnet-private-1c
  ]
  capacity_type = "ON_DEMAND"
  launch_template {
    id      = aws_launch_template.node_group.id
    version = aws_launch_template.node_group.latest_version
  }

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  instance_types = [
    "t4g.medium"
  ]
  # https://aws.amazon.com/jp/bottlerocket/?amazon-bottlerocket-whats-new.sort-by=item.additionalFields.postDateTime&amazon-bottlerocket-whats-new.sort-order=desc
  ami_type = "BOTTLEROCKET_ARM_64"

  update_config {
    # Desired max number of unavailable worker nodes during node group update
    max_unavailable = 1
  }
}

resource "aws_launch_template" "node_group" {
  name = "eks-test-ng-template"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }
}

######
# EKS Addons
######
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.eks_test_cluster.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.eks_test_cluster.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "core_dns" {
  cluster_name = aws_eks_cluster.eks_test_cluster.name
  addon_name   = "coredns"
}
