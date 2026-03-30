provider "google" {
  project = var.project_id
  region  = var.region
}

module "app" {
  source = "./modules/cloud_run_app"

  project_id                    = var.project_id
  region                        = var.region
  service_name                  = var.service_name
  image                         = var.image
  ingress                       = var.ingress
  container_port                = var.container_port
  cpu                           = var.cpu
  memory                        = var.memory
  runtime_service_account_email = var.runtime_service_account_email
  labels                        = var.labels
  vpc_connector                 = var.vpc_connector
  vpc_egress                    = var.vpc_egress
  allow_unauthenticated         = var.allow_unauthenticated
}
