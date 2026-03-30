variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "service_name" {
  type = string
}

variable "image" {
  type = string
}

variable "ingress" {
  type = string
}

variable "container_port" {
  type = number
}

variable "cpu" {
  type = string
}

variable "memory" {
  type = string
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "vpc_connector" {
  type        = string
  default     = null
  description = "Optional Serverless VPC Access connector resource name (full URI). Leave unset for public-only egress."
  nullable    = true
}

variable "vpc_egress" {
  type        = string
  default     = "PRIVATE_RANGES_ONLY"
  description = "Egress through VPC connector: PRIVATE_RANGES_ONLY or ALL_TRAFFIC."

  validation {
    condition     = contains(["PRIVATE_RANGES_ONLY", "ALL_TRAFFIC"], var.vpc_egress)
    error_message = "vpc_egress must be PRIVATE_RANGES_ONLY or ALL_TRAFFIC."
  }
}

variable "allow_unauthenticated" {
  type        = bool
  default     = false
  description = "If true, grant roles/run.invoker to allUsers (public HTTP). Requires ingress that allows external traffic (e.g. INGRESS_TRAFFIC_ALL)."
}
