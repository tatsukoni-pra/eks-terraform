######
# Nat Gateway
######
# import {
#   to = aws_nat_gateway.nat_tatsukoni_test
#   id = "nat-0187fb64b328702ef"
# }

######
# Private Subnet
######
# import {
#   to = aws_subnet.private_1a
#   id = "subnet-0fc6ea4c93a919961"
# }

# import {
#   to = aws_subnet.private_1c
#   id = "subnet-0cdf0dfdbaff1ff9e"
# }

######
# Route Table
######
# import {
#   to = aws_route_table.private
#   id = "rtb-04cc394fe7657fa72"
# }

# import {
#   to = aws_route_table_association.private_assoc_1a
#   id = "subnet-0fc6ea4c93a919961/rtb-04cc394fe7657fa72"
# }

# import {
#   to = aws_route_table_association.private_assoc_1c
#   id = "subnet-0cdf0dfdbaff1ff9e/rtb-04cc394fe7657fa72"
# }

######
# ALB
######
# import {
#   to = aws_lb.eks_test_alb
#   id = "arn:aws:elasticloadbalancing:ap-northeast-1:083636136646:loadbalancer/app/eks-test-alb/54701760c6c86289"
# }

# import {
#   to = aws_lb_listener.http
#   id = "arn:aws:elasticloadbalancing:ap-northeast-1:083636136646:listener/app/eks-test-alb/54701760c6c86289/e0680b3bf324ba59"
# }

######
# TargetGroup
######
# import {
#   to = aws_lb_target_group.nginx
#   id = "arn:aws:elasticloadbalancing:ap-northeast-1:083636136646:targetgroup/tg-nginx/a64b168434cf5f39"
# }
