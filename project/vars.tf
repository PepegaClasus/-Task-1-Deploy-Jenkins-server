variable "region" {
    type = string
    default = "eu-west-2"
}

variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
}

variable "subnet_availability_zone" {
    type = string
    default = "eu-west-2b"
}

variable "subnet_cidr_block" {
    type = string
    default = "10.0.1.0/24"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "ami" {
    type = string
    default = "ami-0bd2099338bc55e6d"
}

variable "instance_name" {
    type = string
    default = "Jenkins"
}

variable "key_name" {
    type = string
    default = "RSA_KEY"
}