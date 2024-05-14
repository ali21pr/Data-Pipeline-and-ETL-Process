# Service Account
variable "service_accounts" {
  type = map(object({
    purpose      = string
    display_name = string
    description  = string
  }))
}

#bucket_Cloud_Storage

variable "buckets" {
  type = map(object({
    identifier         = string
    location           = string
    storage_class      = string
    versioning_enabled = bool
  }))
}

#Dataset Bigquery 
variable "datasets" {
  type = map(object({
    dataset_id          = string
    location_dataset    = string
    description_dataset = string
  }))
}

# Bigquery Table
variable "tables" {
  type = map(object({
    table_id   = string
    dataset_id = string
    schema     = any
  }))
}

# Dataflow job 

variable "name_dataflow" {
  type = string
}
variable "project_id" {
  description = "The ID to give the project. If not provided, the `name` will be used."
  type        = string
  default     = ""
}
variable "region_dataflow" {
  type = string
}
variable "template_name" {
  description = "The name of the dataflow template."
  default     = "text-to-bigquery"
}

# Enable Api
variable "activate_apis" {
  description = "The list of apis to activate within the project"
  type        = list(string)
  default     = ["compute.googleapis.com"]
}

# cloud function 
variable "name_func" {
  type = string
}
variable "description" {
  type = string
}
variable "runtime" {
  type = string
}
variable "entry_point" {
  type = string
}
variable "available_memory_mb" {
  type = number
}

# vpc
variable "name_vpc" {
  type = string
}
variable "auto_create_subnetworks" {
  type = bool
}

#subnet 
variable "name_subnet" {
  type = string
}
variable "region_subnet" {
  type = string
}
variable "ip_cidr_range" {
  type = string
}
variable "range_namesecondry_pods" {
  type = string
}
variable "ip_cidr_range_secondry_pods" {
  type = string
}
variable "range_namesecondry_svc" {
  type = string
}
variable "ip_cidr_range_secondry_svc" {
  type = string
}


# cloud Composer
variable "name_composer_environment" {
  type = string
}
variable "machine_type" {
  type = string
}
variable "image_version" {
  type = string
}
variable "node_count" {
  type = number
}

# Compute Engine 

variable "compute_machine_type" {
  type = string
}
variable "name_instance" {
  type = string
}
variable "zone" {
  type = string
}
/*
variable "image" {
  type = string
}*/
variable "tags" {
  type = list(string)
}

#iap 
variable "firewall_rules" {
  description = "Configuration for firewall rules"
  type = map(object({ 
    protocol      = string  # Protocol, e.g., tcp, udp
    ports         = list(string)  # List of ports, e.g., ["22", "80"]
    source_ranges = list(string)  # Source IP ranges, e.g., ["0.0.0.0/0"]
    target_tags   = list(string)  # Target tags applied to the VMs
  }))
}
