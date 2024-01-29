# get this content by Googling: "terraform google cloud provider"
# "use provider" -> copy and paste it to main.tf

# install extension "terraform" by hashicorp

# export GOOGLE_APPLICATION_CREDENTIALS=<path to your service account key.json>

# then we will create a GCS bucket. Google it: "terraform google cloud storage bucket" click on first link
# copy and paste the example here
# definition of each block like "lifecycle_rule", you can find it on the same page by searching it CMD+F

# RUN: "terraform plan", to see what changes will be done based on our *.tf file (no implementation yet).
  # it also to check if our *.tf file is not having issues
# if everything ok, then
# RUN: "terraform apply" --> will produce file *.tfstate which contains what resources we have made.
# RUN: "terraform destroy" --> see what will be destroyes, confirm with 'yes'. to destroy all resources we made, so will not incur cost


##### === Video: DE Zoomcamp 1.3.3 - Terraform Variables ############
# google for "terraform bigquery dataset" and click on the 1st link
# terraform docs is nice, but the example usage is sometimes too much.
# we can do like above activities, search the keyword and see which ones are required and optional.
# for personal learning, just copy those 'required'
  # resource "google_bigquery_dataset" "demo-dataset" {
  #   dataset_id = "demo_dataset"
  # }
# RUN: terraform apply -> see what changes to do. see those that are not "(known after apply)". --> go back to the documentation, and see what that is about. in case we need to change accordingly
# RUN: terraform destroy

# => create variables.tf
  # this variables is nice when we define a variable once, then can be used multiple times accorss others *.tf file like main.tf. so it will be consistent
  # variables can be refered by using var.<varname>
  # DO: modify the main.tf to use the vars in variables.tf
  # unset GOOGLE_APPLICATION_CREDENTIALS
    # put it in variable as filepath. and load it using file() function in main.tf. Terraform has many functions to use.