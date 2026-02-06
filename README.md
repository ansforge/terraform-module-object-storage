# terraform-module-object-storage

Terraform module to manage OVH Object Storage (S3) resources.

## Description

This module creates and configures the resources required for an OVH Object Storage (S3) bucket:

- a project user in OVH with the appropriate role (`objectstore_operator`),
- an S3 credentials pair associated with that user,
- the S3 bucket itself, with optional versioning, server-side encryption and replication.

The module exposes the S3 credentials (access key / secret) as outputs so they can be used with S3/AWS-compatible tools.

## Prerequisites

- Terraform >= 1.0.0
- OVH provider >= 2.8.0
- OVH credentials configured (via environment variables or OVH config file)

## Required environment variables

Before running Terraform, export your OVH credentials (or configure them via the OVH configuration file):

```bash
export OVH_ENDPOINT=ovh-eu
export OVH_APPLICATION_KEY=your_application_key
export OVH_APPLICATION_SECRET=your_application_secret
export OVH_CONSUMER_KEY=your_consumer_key
```

## Usage

### Minimal example

```hcl
module "object_storage" {
  source = "git::https://github.com/ansforge/terraform-module-object-storage.git?ref=ovh/v1.0.0"

  s3 = {
    region             = "eu-west-rbx"
    replica_region = ""                # leave empty if replication is disabled
    bucket_name        = "my-bucket-name"
    enable_replication = false
    enable_versioning  = false
    enable_encryption  = false
  }

  ovh = {
    endpoint   = "ovh-eu"
    project_id = "your-ovh-project-id"
  }
}
```

### Full example (versioning / encryption / replication)

```hcl
module "object_storage" {
  source = "git::https://github.com/ansforge/terraform-module-object-storage.git?ref=ovh/v1.0.0"

  s3 = {
    region             = "eu-west-rbx"
    replica_region     = "eu-west-gra"
    bucket_name        = "production-bucket"
    enable_replication = true
    enable_versioning  = true
    enable_encryption  = true
  }

  ovh = {
    endpoint   = "ovh-eu"
    project_id = "your-ovh-project-id"
  }
}

output "aws_access_key" {
  value = module.object_storage.aws_access_key
}

output "aws_secret_key" {
  value     = module.object_storage.aws_secret_key
  sensitive = true
}
```

> Note: the module always creates a project user and an associated S3 credentials pair. There is no variable to disable
> credential creation in the current version of the module.

## Outputs

The module exposes the following outputs:

- `aws_access_key`: S3 access key ID.
- `aws_secret_key`: S3 secret access key (sensitive).

## License

See the [LICENSE](LICENSE) file in the parent repository.
