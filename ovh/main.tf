resource "ovh_cloud_project_user" "s3_admin_user" {
  description  = "Utilisateur associé au S3 ${lower(var.s3.bucket_name)} créé par terraform pour générer le S3 access key."
  role_name    = "objectstore_operator"
  service_name = var.ovh.project_id
}

resource "ovh_cloud_project_user_s3_credential" "s3_admin_cred" {
  user_id      = ovh_cloud_project_user.s3_admin_user.id
  service_name = var.ovh.project_id
}

#resource "ovh_cloud_project_user" "s3_replica_admin_user" {
#  count  = var.s3.enable_replication ? 1 : 0
#  description  = "Utilisateur associé au S3 replica-${lower(var.s3.bucket_name)} créé par terraform pour générer le S3 access key."
#  role_name    = "objectstore_operator"
#  service_name = var.ovh.project_id
#}

#resource "ovh_cloud_project_user_s3_credential" "s3_replica_admin_cred" {
#  count  = var.s3.enable_replication ? 1 : 0
#  user_id      = ovh_cloud_project_user.s3_replica_admin_user[0].id
#  service_name = var.ovh.project_id
#}

#resource "aws_s3_bucket" "s3principal" {
#  provider = aws.s3principal
#  bucket = var.s3.bucket_name
#  tags = {
#    Description        = var.s3.bucket_description
#    Environment = var.s3.environnement
#  }
#}

#resource "aws_s3_bucket" "s3replica" {
#  count  = var.s3.enable_replication ? 1 : 0
#  provider = aws.s3replica
#  bucket = "replica-${lower(var.s3.bucket_name)}"  
#  tags = {
#    Description        = "S3 de replicat du s3 ${lower(var.s3.bucket_name)}"
#    Environment = var.s3.environnement
#  }
#}

#resource "aws_s3_bucket_versioning" "s3principal" {
#  count  = var.s3.enable_versioning ? 1 : 0
#  bucket = aws_s3_bucket.s3principal.id
#
#  versioning_configuration {
#    status = "Enabled"
#  }
#}



#resource "aws_s3_bucket_versioning" "s3replica" {
#  count  = var.s3.enable_versioning ? 1 : 0
#  bucket = aws_s3_bucket.s3replica[0].id

#  versioning_configuration {
#    status = "Disabled"
#  }
#}

#resource "aws_s3_bucket_server_side_encryption_configuration" "s3principal" {
#  count  = var.s3.enable_encryption ? 1 : 0
#  bucket = aws_s3_bucket.s3principal.id

#  rule {
#    apply_server_side_encryption_by_default {
#      sse_algorithm = "AES256"
#    }
#  }
#}


#resource "aws_s3_bucket_server_side_encryption_configuration" "s3replica" {
#  count  = var.s3.enable_encryption ? 1 : 0
#  bucket = aws_s3_bucket.s3replica[0].id

#  rule {
#    apply_server_side_encryption_by_default {
#      sse_algorithm = "AES256"
#    }
#  }
#}


#resource "aws_s3_bucket_replication_configuration" "s3principal" {
#  count  = var.s3.enable_replication ? 1 : 0
#  depends_on = [aws_s3_bucket_versioning.s3principal]
#
#  bucket = aws_s3_bucket.s3principal.id
#
#  rule {
#    id     = "replication-rule"
#    status = "Enabled"
#
#    destination {
#      bucket        = aws_s3_bucket.s3replica[0].id
#      storage_class = "STANDARD"
#    }
#
#    filter {
#      prefix = ""
#    }
#  }

# Créer un bucket Object Storage
resource "ovh_cloud_project_storage" "s3principal" {
  service_name = var.ovh.project_id # Remplacer par votre OVHcloud project ID
  region_name = upper(var.s3.region) # Remplacer par la région voulue en majuscule.
  name = var.s3.bucket_name
  owner_id = ovh_cloud_project_user.s3_admin_user.id
  versioning = {
    status = var.s3.enable_versioning ? "enabled" : "disabled"
  }
  encryption ={
    sse_algorithm = var.s3.enable_encryption ? "AES256" : "plaintext"
  }
  
  replication = var.s3.enable_replication ? {
    rules = [ 
    {
      id     = "replication-rule"
      status = "enabled"
      delete_marker_replication = "enabled"
      priority = 1

      destination = {
        name        = "replica-${var.s3.bucket_name}"
        region = upper(var.s3.replica_region)
      }
      filter = {
        prefix = ""
      }
    }]
  }:{}
}
