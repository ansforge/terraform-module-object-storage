# bucket_policy.tf

locals {
  # Politiques prédéfinies par rôle
  policy_templates = {
    read_only = {
      actions = [
        "s3:GetObject",
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:GetObjectVersion",
      ]
    }
    read_write = {
      actions = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:GetObjectVersion",
        "s3:PutObjectAcl",
      ]
    }
    admin = {
      actions = ["s3:*"]
    }
  }

  # Construction des statements pour chaque utilisateur
  user_policy_statements = [
    for user in var.bucket_users : {
      Sid    = "UserAccess-${replace(user.username, "/[^a-zA-Z0-9]/", "-")}"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::*:user/${user.username}"
      }
      Action = user.policy == "custom" ? (
        jsondecode(user.custom_policy_json).actions
      ) : local.policy_templates[user.policy].actions
      Resource = [
        "arn:aws:s3:::${var.bucket_name}",
        "arn:aws:s3:::${var.bucket_name}/*",
      ]
    }
  ]

  # Politique bucket finale (fusion avec une éventuelle politique existante)
  bucket_policy_document = jsonencode({
    Version   = "2012-10-17"
    Statement = local.user_policy_statements
  })
}

resource "aws_s3_bucket_policy" "this" {
  count  = length(var.bucket_users) > 0 ? 1 : 0
  bucket = var.bucket_name
  policy = local.bucket_policy_document
}
