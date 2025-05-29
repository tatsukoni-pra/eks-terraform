######
# Nat Gateway
######
resource "aws_nat_gateway" "nat_tatsukoni_test" {
  allocation_id = "eipalloc-0899896b131bc75b4"
  subnet_id     = "subnet-0b59531acff265d5d" # tatsukoni-demo-subnet-public-1a

  tags = {
    Name = "nat-tatsukoni-test"
  }
}

######
# Private Subnet
######
resource "aws_subnet" "private_1a" {
  vpc_id            = "vpc-025645e04c921bd7c" # tatsukoni-demo-vpc
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "tatsukoni-demo-subnet-private-1a"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id            = "vpc-025645e04c921bd7c" # tatsukoni-demo-vpc
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "tatsukoni-demo-subnet-private-1c"
  }
}

######
# Private Route Table
######
resource "aws_route_table" "private" {
  vpc_id = "vpc-025645e04c921bd7c" # tatsukoni-demo-vpc

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_tatsukoni_test.id
  }
  // route = []

  tags = {
    Name = "tatsukoni-demo-private-table"
  }
}

resource "aws_route_table_association" "private_assoc_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_assoc_1c" {
  subnet_id      = aws_subnet.private_1c.id
  route_table_id = aws_route_table.private.id
}
