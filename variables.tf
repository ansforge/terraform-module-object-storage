variable "s3" {
  type = object({
    region             = string,
    replica_region     = string
    bucket_name        = string
    enable_replication = bool
    enable_versioning  = bool
    enable_encryption  = bool
  })
}


# Ajout dans variables.tf
variable "bucket_users" {
  description = "Liste des utilisateurs S3 avec leur politique d'accès respective."
  type = list(object({
    username    = string
    access_key  = string
    secret_key  = string
    policy      = string # "read_only" | "read_write" | "admin" | "custom"
    custom_policy_json = optional(string, null) # Utilisé uniquement si policy = "custom"
  }))
  default = []
  sensitive = true
}

variable "ovh" {
  type = object({
    project_id = string
  })
}
