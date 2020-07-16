/*
/---------------------------------------\
| Terraform github actions demo - GCP   |
|---------------------------------------|
| Author: Mike Winslow                  |
| E-mail: michael.winslow@broadcom.com  |
\---------------------------------------/
*/
//Variables

variable "project_name" {
  //type        = "string"
  description = "The name of the project to instanciate the instance at."
  default     = "tssecurity-276816"
}

variable "region_name" {
  //type        = "string"
  description = "The region that this terraform configuration will instanciate at."
  default     = "europe-west1"
}

variable "zone_name" {
  //type        = "string"
  description = "The zone that this terraform configuration will instanciate at."
  default     = "europe-west1-b"
}

variable "machine_size" {
  //type        = "string"
  description = "The size that this instance will be."
  //default     = "f1-micro"
  default     = "e2-medium"
}

variable "image_name" {
  //type        = "string"
  description = "The kind of VM this instance will become"
  default     = "ubuntu-os-cloud/ubuntu-1804-lts"
}

variable "network" {
  description = "The name of the subnetwork create this instance in."
  default     = "default"
}

variable "subnetwork" {
  description = "The name of the subnetwork create this instance in."
  default     = "ci-cd"
}

variable "tags" {
  type        = list(string)
  default     = ["cicd-block-ext","cicd-allow-int"]
  description = "Network tags, provided as a list"
}

// Secure Access Cloud
variable "tenant_domain" {
  default = "symcrbrown.luminatesite.com"
}
variable "luminate_user" {
  default = "joe@tssecurity.co.il"
}
variable "luminate_group" {
  default = "Admins"
  //default = "Developer"
}

// GitHub
variable "git_repo" {
  default = ""
}
variable "git_branch" {
  default = ""
}
