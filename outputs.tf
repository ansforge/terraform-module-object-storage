output "aws_access_key" {
  description = "Clé d'accès pour le s3"
  value       = ovh_cloud_project_user_s3_credential.s3_admin_cred.access_key_id
}

output "aws_secret_key" {
  description = "clé secrète pour le s3"
  value       = ovh_cloud_project_user_s3_credential.s3_admin_cred.secret_access_key
  sensitive   = true
}

#output "aws_replica_access_key" {
#  description = "Clé d'accès le s3 replica"
#  value       = ovh_cloud_project_user_s3_credential.s3_replica_admin_cred[0].access_key_id
#}

#output "aws_replica_secret_key" {
#  description = "clé secrète pour le s3 replica"
#  value       = ovh_cloud_project_user_s3_credential.s3_replica_admin_cred[0].secret_access_key
#  sensitive   = true
#}
