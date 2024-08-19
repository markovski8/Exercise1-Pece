resource "aws_s3_bucket" "sitebucket_pece" {
  bucket = var.bucket
  
}

# resource "aws_s3_bucket_policy" "bucket_policy" {
#   bucket = aws_s3_bucket.wordpress_data_bucket.id
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect    = "Allow",
#         Principal = {
#           AWS = "arn:aws:iam::var.accountid.id:role/ec2_role_combined"  # Replace with your IAM role ARN
#         },
#         Action    = [
#           "s3:GetObject",
#           "s3:PutObject",
#           "s3:ListBucket",
#           "s3:GetBucketLocation"
#         ],
#         Resource  = [
#           "arn:aws:s3:::wordpress-data-bucket-pece",
#           "arn:aws:s3:::wordpress-data-bucket-pece/*"
#         ]
#       }
#     ]
#   })
# }
