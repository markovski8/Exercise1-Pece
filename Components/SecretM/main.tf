resource "aws_secretsmanager_secret" "db_credenc3" {
  name        = var.wordpress-db-credenc3
  description = "Credentials for the WordPress RDS database"
}

  

resource "aws_secretsmanager_secret_version" "db_credenc3_version" {
  secret_id     = aws_secretsmanager_secret.db_credenc3.id
  secret_string = jsonencode({
    name     = var.db_name
    username = var.db_username
    password = var.db_password
  })
}