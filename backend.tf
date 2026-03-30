# Partial GCS backend: bucket and prefix are supplied at init time (GCS has no workspace_key_prefix; workspaces use separate objects under prefix).
# (terraform init -backend-config=...). Same pattern as a dedicated backend block in versions.tf.

terraform {
  backend "gcs" {}
}
