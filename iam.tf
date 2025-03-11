######
# Cluster Role
######
resource "aws_iam_role" "eks_test_cluster_role" {
  name = "eks-test-cluster-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name = "eks-test-cluster-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_test_cluster_role_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_test_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# https://docs.aws.amazon.com/ja_jp/eks/latest/userguide/security-groups-pods-deployment.html
# resource "aws_iam_role_policy_attachment" "eks_test_cluster_role_AmazonEKSVPCResourceController" {
#   role       = aws_iam_role.eks_test_cluster_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
# }
