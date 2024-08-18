output "secret_name" {
  value = jsondecode(aws_secretsmanager_secret_version.db_credenc3_version.secret_string)["name"]
  
}

output "secret_user" {
  value = jsondecode(aws_secretsmanager_secret_version.db_credenc3_version.secret_string)["username"]
  
}
output "secret_pass" {
  value = jsondecode(aws_secretsmanager_secret_version.db_credenc3_version.secret_string)["password"]
  sensitive = true
}

output "db_credenc3_secret_id" {
  description = "The Secret ID of the WordPress RDS database credentials"
  value       = aws_secretsmanager_secret.db_credenc3.id
}
