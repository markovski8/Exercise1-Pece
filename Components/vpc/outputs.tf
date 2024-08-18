output "private_subnet_id" {
  value = aws_subnet.PrivateSubnet.id
}

output "public_subnet_id" {
  value = aws_subnet.PublicSubnet.id
}

output "vpc_id" {
  value = aws_vpc.MyVPC.id
}

output "web_server_security_group_id" {
  value = aws_security_group.web_server_sg.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds_sg.id
}

output "rds_subnet_group_name" {
  value = aws_db_subnet_group.example.name  # Ensure this matches what you use in RDS module
}