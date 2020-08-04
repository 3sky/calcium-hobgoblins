variable "project" {
  type = string
  default = "creeping-hobgoblins"
}

variable "path" {
  type = string
  default = "auth.json"
}

variable "service_ip" {
  type = list(string)
  default = ["8.8.8.8"]
}


