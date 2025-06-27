resource "aws_security_group" "pod_sg" {
  name        = "pod-sg"
  description = "Security group for pods"
  vpc_id      = "vpc-025645e04c921bd7c" # tatsukoni-demo-vpc

  # インバウンドルールは定義しない

  # アウトバウンドルールは全て許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pod-sg"
  }
}

resource "aws_security_group" "target_sg" {
  name        = "target-sg"
  description = "Security group for Target Resource"
  vpc_id      = "vpc-025645e04c921bd7c" # tatsukoni-demo-vpc

  # インバウンドルールは pod-sg からの全ポートを許可
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.pod_sg.id]
  }

  # アウトバウンドルールは全て許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "target-sg"
  }
}
