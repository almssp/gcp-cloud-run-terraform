# Production environment.
# To lock down prod: in this file set
#   ingress               = "INGRESS_TRAFFIC_INTERNAL_ONLY"
#   allow_unauthenticated = false

project_id = "freestar-491214"
region     = "us-central1"
image      = "us-docker.pkg.dev/cloudrun/container/hello"

# vpc_connector = "projects/freestar-491214/locations/us-central1/connectors/run-vpc-connector"
# vpc_egress    = "PRIVATE_RANGES_ONLY"
