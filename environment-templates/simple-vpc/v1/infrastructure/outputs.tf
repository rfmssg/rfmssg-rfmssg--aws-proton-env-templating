output "VpcId" {
  value = aws_vpc.Main.id
}

output "PublicSubnetOneId" {
  value = aws_subnet.publicsubnets.id
}

output "PrivateSubnetOneId" {
  value = aws_subnet.privatesubnets.id
}

