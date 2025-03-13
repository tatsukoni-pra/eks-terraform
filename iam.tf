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

######
# Node Role
######
resource "aws_iam_role" "node_role" {
  name = "eks-test-node-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
}
EOF

  tags = {
    Name = "eks-test-node-role"
  }
}

resource "aws_iam_role_policy_attachment" "node_role_AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_role_AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node_role_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
