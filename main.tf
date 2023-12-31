provider "aws" {
  region = "us-east-1"  
}

# Create an IAM User
resource "aws_iam_user" "itc6345_user" {
  name = "manan"
}


# Create a custom policy
resource "aws_iam_policy" "itc6345_attach_policy" {
  name = "allow-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Effect = "Allow",
        "Resource": "*",
	Condition = {
          StringEquals = {
            "aws:username" : "manan"  
          }
        }
      },
    ],
  })
}

# Attach the custom policy to the IAM user
resource "aws_iam_user_policy_attachment" "attach_policy" {
  policy_arn = aws_iam_policy.itc6345_attach_policy.arn
  user = aws_iam_user.itc6345_user.name
}

# Create a policy that revokes permissions
resource "aws_iam_policy" "itc6345_revoke_policy" {
  name = "revoke-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:RebootInstances"
        ],
        Effect = "Deny",
        "Resource": "*",
	Condition = {
          StringEquals = {
            "aws:username" : "manan"  
          }
        }
      },
    ],
  })
}

# Attach the revoke policy to the IAM user
resource "aws_iam_user_policy_attachment" "attach_revoke_policy" {
  policy_arn = aws_iam_policy.itc6345_revoke_policy.arn
  user = aws_iam_user.itc6345_user.name
}

# Delete the IAM user
resource "aws_iam_user" "delete_user" {
  name = "manan"
  force_destroy = true
}