provider "aws" {
    region  = var.region
    access_key = "AKIAVTBQWG6P7NZBDH4N"
    secret_key = "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"
    
}


module "vpc" {
    source = "../modules/vpc"
    vpc_cidr_block = var.vpc_cidr_block
    subnet_availability_zone = var.subnet_availability_zone
    subnet_cidr_block = var.subnet_cidr_block
}

