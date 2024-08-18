# Combined IAM Role for EC2
resource "aws_iam_role" "ec2_role_combined" {
  name = "ec2_role_combined"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Policy for S3 Access
resource "aws_iam_policy" "ec2_s3_policy" {
  name        = "ec2_s3_policy"
  description = "Policy for EC2 to access S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "s3:ListAllMyBuckets",
        Resource  = "*"
      },
      {
        Effect    = "Allow",
        Action    = "s3:ListBucket",
        Resource  = "arn:aws:s3:::wordpress-data-bucket-pece"
      },
      {
        Effect    = "Allow",
        Action    = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource  = "arn:aws:s3:::wordpress-data-bucket-pece/*"
      }
    ]
  })
}
# rds policy for ec2
resource "aws_iam_policy" "rds_policy" {
  name        = "ec2_rds_connect"
  description = "Policy for EC2 to access RDS"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "rds-db:connect"
        ],
        Resource = "*"
      }
    ]
  })
}
# Policy for Secrets Manager Access
# resource "aws_iam_policy" "ec2_secrets_policy" {
#   name        = "ec2_secrets_policy"
#   description = "Policy allowing EC2 to access Secrets Manager secrets"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect    = "Allow",
#         Action    = [
#           "secretsmanager:GetSecretValue",
#           "secretsmanager:DescribeSecret"
#         ],
#         Resource  = "arn:aws:secretsmanager:secret:wordpress-db-credenc3"
#       }
#     ]
#   })
# }

# Data source to get AWS region
data "aws_region" "current" {}

# Data source to get AWS account ID
data "aws_caller_identity" "current" {}

#Policy for Secrets Manager Access
resource "aws_iam_policy" "ec2_secrets_policy" {
  name        = "ec2_secrets_policy"
  description = "Policy allowing EC2 to access Secrets Manager secrets"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        # Resource = "arn:aws:secretsmanager:${var.region}:${var.accountid}:secret:${var.wordpress-db-credenc3}"
        Resource = var.secret_arn
      }
    ]
  })
}


# Attach S3 Policy to Role
resource "aws_iam_role_policy_attachment" "ec2_role_s3_policy" {
  policy_arn = aws_iam_policy.ec2_s3_policy.arn
  role      = aws_iam_role.ec2_role_combined.name
}

# Attach Secrets Manager Policy to Role
resource "aws_iam_role_policy_attachment" "ec2_role_secrets_policy" {
  policy_arn = aws_iam_policy.ec2_secrets_policy.arn
  role      = aws_iam_role.ec2_role_combined.name
}
# attach rds policy to ec2
resource "aws_iam_role_policy_attachment" "ec2_role_rds_attach" {
  policy_arn = aws_iam_policy.rds_policy.arn
  role = aws_iam_role.ec2_role_combined.name
  
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role_combined.name
}

# EC2 Instance
resource "aws_instance" "webServer" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.security_group_id]

#   user_data = <<-EOF
#     #!/bin/bash
#     sudo dnf update -y
#     sudo dnf install -y httpd
#     sudo systemctl start httpd
#     sudo systemctl enable httpd
#     echo "<html><body><h1>Apache is running on Amazon Linux 2023</h1></body></html>" | sudo tee /var/www/html/index.html
  
#     EOF

#   tags = {
#     Name = "Web Server"
#   }
# }

 user_data = <<-EOF
    #!/bin/bash
    sudo dnf update -y
    sudo dnf install -y httpd php php-fpm php-mysqlnd
    sudo systemctl start httpd
    sudo systemctl enable httpd
    sudo systemctl start php-fpm
    sudo systemctl enable php-fpm
    echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

    
    EOF2

    sudo mkdir -p /var/www/example
    echo "<html><body><h1>Welcome to Example.com!</h1></body></html>" | sudo tee /var/www/example/index.html

    sudo systemctl restart httpd
    EOF

  tags = {
    Name = "Web Server"
  }
}

