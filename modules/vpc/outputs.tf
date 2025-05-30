# ルートモジュール側でキー名を指定してPublicSubnetのIDを取得する
output "public_subnet_id_map" {
  value = {
    for key, subnet in aws_subnet.public : key => subnet.id
  }
}

# ルートモジュール側でキー名を指定してPrivateSubnetのIDを取得する
output "private_subnet_id_map" {
  value = {
    for key, subnet in aws_subnet.private : key => subnet.id
  }
}

# VPC ID
output "vpc_id" {
  value = aws_vpc.main.id
}
