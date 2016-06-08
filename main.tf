provider "aws" {
  region = "${var.provider_region}"
}

module "vpc" {
  source = "../module-aws-vpc"

  provider_region = "${var.provider_region}"

  vpc_name = "${var.vpc_name}"
  vpc_cidr = "${var.vpc_cidr}"

  az_count = "${var.az_count}"
  az_names = "${var.az_names}"

  nat_cidrs = "${var.nat_cidrs}"
}

module "per_az" {
  source = "../module-aws-per_az"

  provider_region = "${var.provider_region}"
  vpc_id = "${module.vpc.vpc_id}"

  az_count = "${var.az_count}"
  az_names = "${var.az_names}"

  nat_cidrs = "${var.nat_cidrs}"
}
