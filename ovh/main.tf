resource "ovh_cloud_project_user" "s3_admin_user" {
  description  = "Utilisateur associé au S3 ${lower(var.s3.bucket_name)} créé par terraform pour générer le S3 access key."
  role_name    = "objectstore_operator"
  service_name = var.ovh.project_id
}

resource "ovh_cloud_project_user_s3_credential" "s3_admin_cred" {
  user_id      = ovh_cloud_project_user.s3_admin_user.id
  service_name = var.ovh.project_id
}



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
