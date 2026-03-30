output "runtime_service_account_id" {
  description = "Derived runtime service account account_id (service_name + workspace)."
  value       = module.app.runtime_service_account_id
}

output "runtime_service_account_email" {
  description = "Service account email used by Cloud Run revisions."
  value       = module.app.runtime_service_account_email
}

output "service_name" {
  description = "Cloud Run service name."
  value       = module.app.service_name
}

output "service_uri" {
  description = "Main URI of the Cloud Run service."
  value       = module.app.service_uri
}

output "service_id" {
  description = "Cloud Run service resource ID."
  value       = module.app.service_id
}
