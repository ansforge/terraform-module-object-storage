resource "ovh_cloud_project_user" "s3_user" {
  description  = "S3 user for bucket name: ${lower(var.s3.bucket_name)}"
  role_name    = "objectstore_operator"
  service_name = var.ovh.project_id
}

resource "ovh_cloud_project_user_s3_credential" "s3_user_credentials" {
  user_id      = ovh_cloud_project_user.s3_user.id
  service_name = var.ovh.project_id
}

resource "ovh_cloud_project_storage" "bucket" {
  service_name = var.ovh.project_id
  region_name  = upper(var.s3.region)
  name         = var.s3.bucket_name
  owner_id     = ovh_cloud_project_user.s3_user.id

  versioning = {
    status = var.s3.enable_versioning ? "enabled" : "disabled"
  }

  encryption = {
    sse_algorithm = var.s3.enable_encryption ? "AES256" : "plaintext"
  }

  replication = var.s3.enable_replication ? {
    rules = [
      {
        id                        = "replication-rule"
        status                    = "enabled"
        delete_marker_replication = "enabled"
        priority                  = 1

        destination = {
          name   = "replica-${var.s3.bucket_name}"
          region = upper(var.s3.replica_region)
        }
        filter = {
          prefix = ""
        }
    }]
  } : {}
}
