source "googlecompute" "example" {
  project_id   = var.project_id
  source_image = var.source_image
  zone         = var.zone
  ssh_username = var.ssh_username
}

build {
  sources = ["googlecompute.example"]

  provisioner "shell-local" {
    inline = [
      "echo 'This is a provisioner script'"
    ]
  }
}


variable "project_id" {
  type    = string
  default = "velvety-ground-414100"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "service_account_file" {
  type    = string
  default = "/Users/abhaydeshpande/Downloads/pkey-gcloud/velvety-ground-414100-5d0dae2ed105.json"
}

variable "script_path" {
  type    = string
  default = "../scripts/install.sh"
}

variable "source_image" {
  type    = string
  default = "centos-stream-8"
}

variable "image_name" {
  type    = string
  default = "centos-8-custom-image"
}

variable "image_family" {
  type    = string
  default = "centos-stream-8"
}

variable "ssh_username" {
  type    = string
  default = "abhaydeshpande"
}

variable "network" {
  type    = string
  default = "default"
}

variable "tags" {
  type    = list(string)
  default = ["http-server", "https-server"]
}
