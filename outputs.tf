output "aws_access_key" {
  description = "Access key ID for the S3 credential."
  value       = ovh_cloud_project_user_s3_credential.s3_user_credentials.access_key_id
}

output "aws_secret_key" {
  description = "Secret access key for the S3 credential."
  value       = ovh_cloud_project_user_s3_credential.s3_user_credentials.secret_access_key
  sensitive   = true
}
