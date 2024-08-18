resource "aws_db_instance" "wp_db" {
  allocated_storage    = 10
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  identifier           = var.identifier
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = var.rds_subnet_group_name
  vpc_security_group_ids = var.rds_security_group_ids
  multi_az             = false
  publicly_accessible  = false
  skip_final_snapshot  = true
  storage_type         = "gp2"
  

  tags = {
    Name = "wordpress-db"
    Environment = "dev"
  }
}

