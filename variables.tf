variable "s3" {
  type = object({
    region             = string,
    replica_region     = string
    bucket_name        = string
    enable_replication = bool
    enable_versioning  = bool
    enable_encryption  = bool
    bucket_users       = list(object({
       username    = string        # Nom descriptif de l'utilisateur
       description = optional(string, "")
       policy      = string        # "read_only" | "read_write" | "admin" | "custom"
       custom_policy_json = optional(string, null)
       resources          = optional(list(string), ["*"]) # par défaut accès à tout le bucket
     })) 
  })
}


variable "ovh" {
  type = object({
    project_id = string
  })
}
