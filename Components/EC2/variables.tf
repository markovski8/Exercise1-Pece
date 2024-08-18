variable "ami" {}
variable instance_type{}
variable "region" {}
variable "accountid" {}
variable "wordpress-db-credenc3" {}
variable "secret_arn" {}

variable "associate_public_ip_address" {
    default = true
  
}

variable "subnet_id" {
    description = "subnet id za ec2"
  
}

variable "security_group_id" {
  description = "The ID of the security group to associate with the EC2 instance"
  type        = string
}

variable "key_name" {}
  

  
