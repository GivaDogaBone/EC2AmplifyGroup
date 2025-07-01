terraform {
  required_version = ">= 1.0.0" # Ensure that the Terraform version is 1.0.0 or higher

  required_providers {
    aws = {
      source = "hashicorp/aws" # Specify the source of the AWS provider
      version = "~> 4.0"        # Use a version of the AWS provider that is compatible with version
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Set the AWS region to US East (N. Virginia)
}

# Create the IAM Group
resource "aws_iam_group" "ec2_amplify_group" {
  name = "EC2AmplifyGroup"
}

# Define IAM Policy for EC2 and Amplify administration with least privilege
resource "aws_iam_policy" "ec2_amplify_policy" {
  name        = "EC2AmplifyLimitedAdminPolicy"
  description = "Limited policy for administering EC2 and Amplify"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # EC2 permissions
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "ec2:RunInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:TerminateInstances",
          "ec2:CreateTags",
          "ec2:DeleteTags"
        ]
        Resource = "*"
      },
      # Amplify permissions
      {
        Effect = "Allow"
        Action = [
          "amplify:CreateApp",
          "amplify:DeleteApp",
          "amplify:GetApp",
          "amplify:ListApps",
          "amplify:StartJob",
          "amplify:StopJob",
          "amplify:UpdateApp",
          "amplify:CreateBranch",
          "amplify:DeleteBranch",
          "amplify:GetBranch",
          "amplify:ListBranches",
          "amplify:CreateDeployment",
          "amplify:StartDeployment"
        ]
        Resource = "*"
      },
      # Additional permissions needed for Amplify to work with other services
      {
        Effect = "Allow"
        Action = [
          "cloudfront:CreateInvalidation",
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "iam:PassRole"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "iam:PassedToService": "amplify.amazonaws.com"
          }
        }
      }
    ]
  })
}

# Attach the Policy to the Group
resource "aws_iam_group_policy_attachment" "ec2_amplify_policy_attachment" {
  group      = aws_iam_group.ec2_amplify_group.name
  policy_arn = aws_iam_policy.ec2_amplify_policy.arn
}