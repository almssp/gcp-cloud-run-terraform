variable "project_id" {
  type        = string
  description = "GCP project ID where Cloud Run is deployed."
}

variable "region" {
  type        = string
  description = "GCP region for the Cloud Run service."
  default     = "us-central1"
}

variable "service_name" {
  type        = string
  description = "Cloud Run service name."
}

variable "image" {
  type        = string
  description = "Container image (e.g. gcr.io/PROJECT/image:tag)."
}

variable "ingress" {
  type        = string
  description = "Ingress setting for Cloud Run v2 (e.g. INGRESS_TRAFFIC_INTERNAL_ONLY)."
  default     = "INGRESS_TRAFFIC_INTERNAL_ONLY"
}

variable "container_port" {
  type        = number
  description = "Container port."
  default     = 8080
}

variable "cpu" {
  type        = string
  description = "CPU limit (Cloud Run v2 string, e.g. 1)."
  default     = "1"
}

variable "memory" {
  type        = string
  description = "Memory limit (e.g. 512Mi)."
  default     = "512Mi"
}

variable "runtime_service_account_email" {
  type        = string
  description = "Email of the runtime service account for the Cloud Run revision (platform-provided)."
}

variable "labels" {
  type        = map(string)
  description = "Optional resource labels."
  default     = {}
}

variable "vpc_connector" {
  type        = string
  default     = null
  description = "Optional VPC connector resource name for private egress (platform-provided)."
  nullable    = true
}

variable "vpc_egress" {
  type        = string
  description = "Egress setting when vpc_connector is set."
  default     = "PRIVATE_RANGES_ONLY"

  validation {
    condition     = contains(["PRIVATE_RANGES_ONLY", "ALL_TRAFFIC"], var.vpc_egress)
    error_message = "vpc_egress must be PRIVATE_RANGES_ONLY or ALL_TRAFFIC."
  }
}

variable "allow_unauthenticated" {
  type        = bool
  description = "Allow unauthenticated invoke (allUsers run.invoker). Use with INGRESS_TRAFFIC_ALL for a public URL."
  default     = false
}
