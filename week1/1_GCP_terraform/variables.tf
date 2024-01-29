variable "credentials" {
  description = "My GCP Credentials"
  default     = "./keys/sugi-learn-service-account.json"
}
variable "project" {
  description = "Project"
  default     = "sugi-learn"
}

variable "region" {
  description = "Region"
  default     = "us-central1"
}
variable "location" {
  description = "Project Location"
  default     = "US"
}

variable "bq_dataset_name" {
  description = "My BigQuery dataset name"
  default     = "demo_dataset"
}

variable "bq_bucket_name" {
  description = "My Storage bucket name"
  default     = "sugi-learn-terraform"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}