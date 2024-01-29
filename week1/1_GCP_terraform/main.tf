# get this content by Googling: "terraform google cloud provider"
# "use provider" -> copy and paste it here
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.13.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project = var.project
  region  = var.region
}

# export GOOGLE_APPLICATION_CREDENTIALS=<path to your service account key.json>

# then we will create a GCS bucket. Google it: "terraform google cloud storage bucket" click on first link
# copy and paste the example here
# definition of each block like "lifecycle_rule", you can find it on the same page by searching it CMD+F
resource "google_storage_bucket" "demo-bucket" { # resource name that TF will handle, then our local name. Later, this can be refered using dot "." as google_storage_bucket.demo-bucket
  name          = var.bq_bucket_name
  location      = var.location
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload" # if we upload large data to GCS and it didnt complete > 1 day, abort it.
    }
  }
}

# RUN: "terraform plan", to see what changes will be done based on our *.tf file (no implementation yet)
# if everything ok, then
# RUN: "terraform apply" --> will produce file *.tfstate which contains what resources we have made.
# RUN: "terraform destroy" --> see what will be destroyes, confirm with 'yes'. to destroy all resources we made, so will not incur cost



##### === Video: DE Zoomcamp 1.3.3 - Terraform Variables ############
# google for "terraform bigquery dataset" and click on the 1st link
# terraform docs is nice, but the example usage is sometimes too much.
# we can do like above activities, search the keyword and see which ones are required and optional.
# for personal learning, just copy those 'required'
resource "google_bigquery_dataset" "demo-dataset" {
  dataset_id = var.bq_dataset_name
  location   = var.location
}
# RUN: terraform apply -> see what changes to do. see those that are not "(known after apply)". --> go back to the documentation, and see what that is about. in case we need to change accordingly
# RUN: terraform destroy

# => create variables.tf
