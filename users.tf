# users.tf

locals {
  policy_actions = {
    read_only = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetObjectVersion",
    ]
    read_write = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetObjectVersion",
      "s3:PutObjectAcl",
    ]
    admin = ["s3:*"]
  }

  users_map = { for u in var.bucket_users : u.username => u }
}

# -------------------------------------------------------
# 1. Création des utilisateurs OVH Cloud Project
# -------------------------------------------------------
resource "ovh_cloud_project_user" "s3_users" {
  for_each = local.users_map

  service_name = var.ovh.project_id
  description  = each.value.description
  role_name    = "objectstore_operator"
}

# -------------------------------------------------------
# 2. Génération des credentials S3 pour chaque utilisateur
# -------------------------------------------------------
resource "ovh_cloud_project_user_s3_credential" "s3_credentials" {
  for_each = local.users_map

  service_name = var.ovh.project_id
  user_id      = ovh_cloud_project_user.s3_users[each.key].id
}

# -------------------------------------------------------
# 3. Application de la policy S3 par utilisateur via OVH
# -------------------------------------------------------
resource "ovh_cloud_project_user_s3_policy" "s3_policies" {
  for_each = local.users_map

  service_name = var.ovh.project_id
  user_id      = ovh_cloud_project_user.s3_users[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "BucketAccess-${replace(each.key, "/[^a-zA-Z0-9]/", "-")}"
        Effect = "Allow"
        Action = each.value.policy == "custom" ? (
          jsondecode(each.value.custom_policy_json).actions
        ) : local.policy_actions[each.value.policy]
        Resource = [
          "arn:aws:s3:::${var.s3.bucket_name}",
          "arn:aws:s3:::${var.s3.bucket_name}/*",
        ]
      }
    ]
  })
}
