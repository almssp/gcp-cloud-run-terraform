# Development environment — merged after common.tfvars (these values win on duplicate keys).

project_id                    = "freestar-491214"
region                        = "us-central1"
image                         = "us-docker.pkg.dev/cloudrun/container/hello"
runtime_service_account_email = "example-api-runtime@freestar-491214.iam.gserviceaccount.com"

# Uncomment when platform provides a connector in this project/region:
# vpc_connector = "projects/freestar-491214/locations/us-central1/connectors/run-vpc-connector"
# vpc_egress    = "PRIVATE_RANGES_ONLY"
