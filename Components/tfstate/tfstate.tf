resource "aws_s3_bucket" "s3tfstatelock" {
    bucket = var.busket-for-tfstate
  
}
resource "aws_dynamodb_table" "db_tfstate_lock" {
  name           = var.terraform_Lock
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

