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
