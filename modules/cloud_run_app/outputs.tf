output "service_name" {
  value = google_cloud_run_v2_service.app.name
}

output "service_uri" {
  value = google_cloud_run_v2_service.app.uri
}

output "service_id" {
  value = google_cloud_run_v2_service.app.id
}
