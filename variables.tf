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



# Liste des utilisateurs
variable "bucket_users" {
  description = "Liste des utilisateurs S3 à créer avec leur politique d'accès sur le bucket."
  type = list(object({
    username    = string        # Nom descriptif de l'utilisateur
    description = optional(string, "")
    policy      = string        # "read_only" | "read_write" | "admin" | "custom"
    custom_policy_json = optional(string, null)
    resources          = optional(list(string), ["*"]) # par défaut accès à tout le bucket
  }))
  default = []
}

variable "ovh" {
  type = object({
    project_id = string
  })
}
