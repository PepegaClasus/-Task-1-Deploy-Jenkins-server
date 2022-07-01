provider "aws" {
    region  = var.region

    
}


module "vpc" {
    source = "../modules/vpc"
    vpc_cidr_block = var.vpc_cidr_block
    subnet_availability_zone = var.subnet_availability_zone
    subnet_cidr_block = var.subnet_cidr_block
}

