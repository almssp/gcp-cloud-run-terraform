output "runtime_service_account_id" {
  value       = local.runtime_service_account_id
  description = "Derived GCP account_id for the runtime service account."
}

output "runtime_service_account_email" {
  value       = google_service_account.runtime.email
  description = "Email of the Terraform-managed runtime service account."
}

output "service_name" {
  value = google_cloud_run_v2_service.app.name
}

output "service_uri" {
  value = google_cloud_run_v2_service.app.uri
}

output "service_id" {
  value = google_cloud_run_v2_service.app.id
}
