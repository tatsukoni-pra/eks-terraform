######
# OIDC Provider
######
# https://shepherdmaster.hateblo.jp/entry/2020/12/20/230038
data "tls_certificate" "cluster" {
  url = aws_eks_cluster.eks_test_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks_test_cluster.identity[0].oidc[0].issuer
}

######
# AWS Load Balancer Controller用 IAM Role
# https://docs.aws.amazon.com/ja_jp/eks/latest/userguide/lbc-helm.html#lbc-helm-iam
# https://docs.aws.amazon.com/ja_jp/eks/latest/userguide/iam-roles-for-service-accounts.html
######
resource "aws_iam_role" "load_balancer_controller" {
  name               = "AwsLoadBalancerController"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${aws_iam_openid_connect_provider.cluster.arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${aws_iam_openid_connect_provider.cluster.url}:aud": "sts.amazonaws.com",
          "${aws_iam_openid_connect_provider.cluster.url}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "load_balancer_controller" {
  role       = aws_iam_role.load_balancer_controller.name
  policy_arn = aws_iam_policy.load_balancer_controller.arn
}

######
# External Secrets Operator用 IAM Policy
# https://external-secrets.io/latest/provider/aws-secrets-manager/
######
data "aws_iam_policy_document" "external_secrets_operator" {
  statement {
    actions   = ["secretsmanager:ListSecrets"]
    resources = ["*"]
  }

  statement {
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = ["arn:aws:secretsmanager:*:*:secret:*"]
  }
}

resource "aws_iam_policy" "external_secrets_operator" {
  name        = "ExternalSecretsOperatorPolicy"
  description = "Policy for External Secrets Operator to access AWS Secrets Manager"
  policy      = data.aws_iam_policy_document.external_secrets_operator.json
}

######
# External Secrets Operator用 IAM Role
# https://external-secrets.io/latest/provider/aws-secrets-manager/
######
resource "aws_iam_role" "external_secrets_operator" {
  name               = "ExternalSecretsOperatorRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${aws_iam_openid_connect_provider.cluster.arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${aws_iam_openid_connect_provider.cluster.url}:aud": "sts.amazonaws.com",
          "${aws_iam_openid_connect_provider.cluster.url}:sub": "system:serviceaccount:external-secrets:cluster-secret-store"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "external_secrets_operator" {
  role       = aws_iam_role.external_secrets_operator.name
  policy_arn = aws_iam_policy.external_secrets_operator.arn
}
