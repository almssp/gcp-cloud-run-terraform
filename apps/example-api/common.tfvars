# Shared across dev and prod for this app.

service_name = "example-api"
# Public internet → service URL (curl/browser without identity token).
ingress               = "INGRESS_TRAFFIC_ALL"
allow_unauthenticated = true
container_port        = 8080
cpu                   = "1"
memory                = "512Mi"

labels = {
  app = "example-api"
}

# Optional: set a shared VPC connector if the same connector is used in every env.
# vpc_connector = "projects/freestar-491214/locations/us-central1/connectors/CONNECTOR_NAME"
# vpc_egress    = "PRIVATE_RANGES_ONLY"
