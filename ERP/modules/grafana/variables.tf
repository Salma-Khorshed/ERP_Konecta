variable "public_subnet_id" {
  type = string
}

variable "ami" {
  type = string
}

variable "sg_id" {
  type = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "influxdb_url" {
  type = string
}
