terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = ">= 3.3.2" 
    }
  }
}

provider "docker" {
    host = "ssh://sadmin@158.160.210.106" 
}

resource "random_password" "mrp" {
  length      = 8
  }

resource "random_password" "mup" {
  length      = 8
  }

resource "docker_image" "mysqlhw" {
  name = "mysql:8"
}

resource "docker_container" "msql" {
  image = docker_image.mysqlhw.image_id
  name  = "msql"
ports {
    internal = 3306
    external = 3306
    protocol = "tcp"
  }
  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mrp.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.mup.result}",
    "MYSQL_ROOT_HOST=%"
  ]
}

