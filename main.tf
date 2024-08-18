# module "tfstate" {
#     source = "./Components/tfstate"
# }

module "vpc" {
  source = "./Components/vpc"
}

module "ec2" {
  source = "./Components/EC2"
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnet_id
  associate_public_ip_address = true
  security_group_id           = module.vpc.web_server_security_group_id
  key_name = var.key_name
  region = var.region
  accountid = var.accountid
  wordpress-db-credenc3 = var.wordpress-db-credenc3
  secret_arn = module.SecretM.db_credenc3_secret_id


}



module "s3" {
    source = ".//Components/s3"
  
}

module "rds" {
  source      = "./Components/Rds"
  identifier = var.identifier
  db_name     = module.SecretM.secret_name
  db_username = module.SecretM.secret_user
  db_password = module.SecretM.secret_pass
  rds_subnet_group_name  = module.vpc.rds_subnet_group_name  
  rds_security_group_ids = [module.vpc.rds_security_group_id]
  # depends_on = [module.SecretM]
}

module "SecretM" {
  source = "./Components/SecretM"
  wordpress-db-credenc3 = var.wordpress-db-credenc3
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

