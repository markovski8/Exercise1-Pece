terraform {
  backend "s3" {
    bucket         = "bucket-for-tfstatefile"  
    key            = "state/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform_Lock"
  }
}