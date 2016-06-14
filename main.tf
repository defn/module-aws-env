provider "aws" {
}

resource "terraform_remote_state" "global" {
  backend = "s3"
  config {
    bucket = "${var.bucket_remote_state}"
    key = "${var.bucket_remote_state}/env-${var.context_org}-global.tfstate"
  }
}

module "vpc" {
  source = "../module-aws-vpc"

  vpc_name = "${var.vpc_name}"
  vpc_cidr = "${var.vpc_cidr}"
}
