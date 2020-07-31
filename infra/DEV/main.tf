locals {
  auth_file = file(var.path)
}

provider "google" {
 credentials = local.auth_file
 project     = var.project
}

module "function" {
  source = "../Module/GKE"
}
