variable "db_name" {
  
}
variable "db_username" {
  description = "The master username for the RDS instance"
  type        = string
}


  variable "db_password" {
  description = "The Secrets Manager secret ID for the RDS password"
  type        = string
  sensitive = true
}

variable "rds_subnet_group_name" {
  description = "The name of the subnet group for the RDS instance"
  type        = string
}

variable "rds_security_group_ids" {
  description = "A list of security group IDs to associate with the RDS instance"
  type        = list(string)
}
variable "identifier" {}