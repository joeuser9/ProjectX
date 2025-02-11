/*
/---------------------------------------\
| Terraform github actions demo - GCP   |
|---------------------------------------|
| Author: Mike Winslow                  |
| E-mail: michael.winslow@broadcom.com  |
\---------------------------------------/
*/
//Main Action

# This is the provider used to spin up the gcloud instance
provider "google" {
  project = var.project_name
  region  = var.region_name
  zone    = var.zone_name
}

# Locks the version of Terraform for this particular use case
terraform {
  required_version = "~>0.12.0"
    backend "gcs" {
    bucket  = "sacbucket1"
    prefix  = "terraform/state"
  }
}

# Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

# Sets the Template File for the sartup script
data "template_file" "startup_script" {
  template = file("scripts/install-deps.tpl")
  vars = {
    git_repo = var.git_repo
    git_branch = var.git_branch
  }
}

# This creates the google instance
resource "google_compute_instance" "default" {
    name = "sac-dev-vm-${random_id.instance_id.hex}"
    machine_type = var.machine_size
    zone = var.zone_name
    tags     = var.tags
boot_disk {
    initialize_params {
        image = var.image_name
    }
  }

network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    network_ip = "10.0.1.5"
  }

metadata = {
    startup-script = data.template_file.startup_script.rendered
  }
}

// Secure Access Cloud (luminate) provider

provider "luminate" {
  api_endpoint = "api.${var.tenant_domain}"
}


resource "luminate_web_application" "nginx" {
  name             = "GCP-SAC-CICD"
  site_id          = "3c10ca64-d3fc-4347-a3af-e5570410c0f2"
  internal_address = "http://10.0.1.5"
}

resource "luminate_web_access_policy" "web-access-policy" {
  name                 = "Default WEB - DevOps"
  identity_provider_id = data.luminate_identity_provider.idp.identity_provider_id
  user_ids             = data.luminate_user.users.user_ids
  group_ids            = data.luminate_group.groups.group_ids
  applications         = [luminate_web_application.nginx.id]
}

// Change for Account in SAC
data "luminate_identity_provider" "idp" {
  identity_provider_name = "azure-ad"
  //identity_provider_name = "local"
}

data "luminate_user" "users" {
  identity_provider_id = data.luminate_identity_provider.idp.identity_provider_id
  users                = [var.luminate_user]
}

data "luminate_group" "groups" {
  identity_provider_id = data.luminate_identity_provider.idp.identity_provider_id
  groups               = [var.luminate_group]
}
