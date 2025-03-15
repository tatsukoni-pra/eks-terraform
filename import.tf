######
# Nat Gateway
######
import {
  to = aws_nat_gateway.nat_tatsukoni_test
  id = "nat-0187fb64b328702ef"
}

######
# Private Subnet
######
import {
  to = aws_subnet.private_1a
  id = "subnet-0fc6ea4c93a919961"
}

import {
  to = aws_subnet.private_1c
  id = "subnet-0cdf0dfdbaff1ff9e"
}

######
# Route Table
######
import {
  to = aws_route_table.private
  id = "rtb-04cc394fe7657fa72"
}

import {
  to = aws_route_table_association.private_assoc_1a
  id = "subnet-0fc6ea4c93a919961/rtb-04cc394fe7657fa72"
}

import {
  to = aws_route_table_association.private_assoc_1c
  id = "subnet-0cdf0dfdbaff1ff9e/rtb-04cc394fe7657fa72"
}
