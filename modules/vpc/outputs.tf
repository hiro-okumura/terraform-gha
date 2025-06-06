output "public_subnet_id_map" {
  description = "A map of subnet names (e.g., 'public1', 'public2') to their public subnet IDs, as defined by 'cidr_block' and 'availability_zone'."
  value = {
    for key, subnet in aws_subnet.public : key => subnet.id
  }
}

output "private_subnet_id_map" {
  description = "A map of subnet names (e.g., 'private1', 'private2') to their private subnet IDs,as defined by 'cidr_block' and 'availability_zone'."
  value = {
    for key, subnet in aws_subnet.private : key => subnet.id
  }
}

output "vpc_id" {
  description = "Main VPC ID"
  value = aws_vpc.main.id
}
