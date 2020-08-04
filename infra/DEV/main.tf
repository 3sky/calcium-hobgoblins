locals {
  auth_file = file(var.path)
}

provider "google" {
 credentials = local.auth_file
 project     = var.project
}

module "kubernetes" {
  source = "../Module/GKE"
}

#module "dns" {
#  source = "../Module/DNS"
#  service_ip = var.service_ip
#}
