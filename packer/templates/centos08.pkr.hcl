packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = "~> 1"
    }
  }
}

source "googlecompute" "example" {
  project_id              = var.project_id
  source_image_family     = "centos-stream-8"
  zone                    = "us-central1-a"
  disk_size               = "20"
  disk_type               = "pd-standard"
  image_name              = "      custom-image-{{timestamp}}"
  image_description       = "       Custom Image using CentOS as source image"
  image_family            = "app-custom-image"
  image_storage_locations = ["us"]
  ssh_username            = "packer"
}

build {
  sources = ["googlecompute.example"]

  // provisioner "shell" {
  //   # Script to zip the directory locally
  //   inline = [
  //     "cd /Users/abhaydeshpande/Desktop/cloud-assignments-spring",
  //     "zip -r webapp-new.zip webapp-new"
  //   ]
  // }

  // provisioner "file" {
  //   # Copy the zip file from local to VM instance
  //   source      = "/Users/abhaydeshpande/Desktop/cloud-assignments-spring/webapp-new.zip"
  //   destination = "/tmp/webapp-new.zip"
  // }

  // provisioner "googlecompute" {
  //   # Copy the zip file into the VM instance
  //   source      = "/tmp/webapp-new.zip"
  //   destination = "/tmp/webapp-new.zip"
  // }

  // provisioner "shell" {
  //   # Extract the zip file and move its contents to the desired location within the VM
  //   inline = [
  //     "cd /tmp",
  //     "unzip webapp-new.zip -d /opt/webapp-new"
  //   ]
  // }

  provisioner "file" {
    source      = "webapp-new.zip"
    destination = "/tmp/webapp-new.zip"
  }

  provisioner "file" {
    source      = "packer/scripts/webapp.service"
    destination = "/tmp/webapp.service"
  }

  provisioner "file" {
    source      = "packer/config.yaml"
    destination = "/tmp/config.yaml"
  }


  provisioner "shell" {
    scripts = [
      "packer/scripts/webapp.sh",
    ]
  }

  // provisioner "shell" {
  //   script = "../scripts/_nodejs.sh"
  // }

  // provisioner "shell" {
  //   script = "../scripts/_postgresql.sh"
  // }

  // provisioner "shell" {
  //   script = "../scripts/_createUser.sh"
  // }
}

variable "project_id" {
  type    = string
  default = "velvety-ground-414100"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}


variable "script_path" {
  type    = string
  default = "../scripts/install.sh"
}

variable "source_image" {
  type    = string
  default = "centos-8-stream"
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



