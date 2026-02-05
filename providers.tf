terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 2.8.0"
    }
  }
}

#provider "aws" {
#  alias                       = "s3principal"
#  region                      = lower(var.s3.region)
#  access_key = ovh_cloud_project_user_s3_credential.s3_admin_cred.access_key_id
#  secret_key = ovh_cloud_project_user_s3_credential.s3_admin_cred.secret_access_key
#  endpoints {
#    s3 = "https://s3.${lower(var.s3.region)}.io.cloud.ovh.net"
#  }
#  skip_credentials_validation = true
#  skip_metadata_api_check     = true
#}

#provider "aws" {
#  alias                       = "s3replica"
#  region                      = lower(var.s3.replica_region)
#  access_key = ovh_cloud_project_user_s3_credential.s3_replica_admin_cred[0].access_key_id
#  secret_key = ovh_cloud_project_user_s3_credential.s3_replica_admin_cred[0].secret_access_key
#  endpoints {
#    s3 = "https://s3.${lower(var.s3.replica_region)}.io.cloud.ovh.net"
#  }
#  skip_credentials_validation = true
#  skip_metadata_api_check     = true
#}


provider "ovh" {
  endpoint = var.ovh.endpoint
}
