provider "aws" {
  region = "${var.provider_region}"
}

resource "terraform_remote_state" "global" {
  backend = "s3"
  config {
    bucket = "${var.bucket_remote_state}"
    key = "${var.bucket_remote_state}/env-${var.context_org}-global.tfstate"
    region = "${var.provider_region}"
  }
}

module "vpc" {
  source = "../module-aws-vpc"

  provider_region = "${var.provider_region}"

  vpc_name = "${var.vpc_name}"
  vpc_cidr = "${var.vpc_cidr}"
}

module "per_az" {
  source = "../module-aws-per_az"

  provider_region = "${var.provider_region}"

  vpc_id = "${module.vpc.vpc_id}"

  az_count = "${var.az_count}"
  az_names = "${terraform_remote_state.global.output.az_names}"

  nat_cidrs = "${var.nat_cidrs}"
}
