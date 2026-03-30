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
  description = "Cloud Run service name. Runtime SA account_id is derived as lower(service_name with _→-) plus -runtime- plus terraform.workspace (truncated to 30 chars)."
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_-]{0,22}$", var.service_name))
    error_message = "service_name must start with a letter; use letters, digits, hyphens, underscores only; keep it short so the derived runtime account_id fits GCP limits."
  }
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
