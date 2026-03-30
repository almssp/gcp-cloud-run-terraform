locals {
  service_slug               = lower(replace(var.service_name, "_", "-"))
  runtime_account_id_raw     = "${local.service_slug}-runtime-${terraform.workspace}"
  runtime_service_account_id = substr(local.runtime_account_id_raw, 0, 30)
}

resource "google_service_account" "runtime" {
  project      = var.project_id
  account_id   = local.runtime_service_account_id
  display_name = "Cloud Run runtime (${var.service_name}, ${terraform.workspace})"
  description  = "Runs ${var.service_name} revisions (${terraform.workspace})."
}

resource "google_cloud_run_v2_service" "app" {
  name     = var.service_name
  location = var.region
  project  = var.project_id
  ingress  = var.ingress
  labels   = var.labels

  template {
    service_account = google_service_account.runtime.email

    containers {
      image = var.image

      ports {
        container_port = var.container_port
      }

      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
      }
    }

    dynamic "vpc_access" {
      for_each = var.vpc_connector == null ? [] : [var.vpc_connector]
      content {
        connector = vpc_access.value
        egress    = var.vpc_egress
      }
    }
  }

  lifecycle {
    ignore_changes = [
      client,
      client_version,
    ]
  }
}

resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  count = var.allow_unauthenticated ? 1 : 0

  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.app.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
