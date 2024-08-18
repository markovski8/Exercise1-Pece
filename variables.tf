variable "region" {}
variable "profile" {}
variable "accountid" {}
variable "ami" {}
variable "identifier" {}
variable "wordpress-db-credenc3" {}
variable "key_name" {}
variable "instance_type" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {
  sensitive   = true
}
