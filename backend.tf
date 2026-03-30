# Partial GCS backend: bucket, prefix, and workspace_key_prefix are supplied at init time
# (terraform init -backend-config=...). Same pattern as a dedicated backend block in versions.tf.

terraform {
  backend "gcs" {}
}
