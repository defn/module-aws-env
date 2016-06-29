provider "aws" { }

module "vpc" {
  source = "../module-aws-vpc"

  vpc_name = "${var.vpc_name}"
  vpc_cidr = "${var.vpc_cidr}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_net16" {
  value = "${join(".",concat(element(split(".",module.vpc.vpc_cidr),0),element(split(".",module.vpc.vpc_cidr),1)))}"
}
