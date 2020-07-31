variable "tags" {
  type    = list(string)
  default = ["k8s-app", "poland", "golang"]
}

variable "zone" {
  type = map
  default = {
    "Poland" = "europe-west3-a"
  }
}

variable "machine_type" {
  type = string
  default = "f1-micro"
}


variable "distro" {
  type = string
  default = "ubuntu-1804-bionic-v20200218"
}


variable "vpc1_name" {
  type = string
  default = "default"
}

variable "user" {
  type = string
  default = "admin"
}

variable "password" {
  type = string
  default = "5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8"
}
