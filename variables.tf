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

variable "ovh" {
  type = object({
    project_id = string
  })
}
