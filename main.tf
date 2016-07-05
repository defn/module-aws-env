provider "aws" { }

module "vpc" {
  source = "../module-aws-vpc"

  bucket_remote_state = "${var.bucket_remote_state}"
  context_org = "${var.context_org}"
  context_env = "${var.context_env}"

  vpc_name = "${var.vpc_name}"
  vpc_cidr = "${var.vpc_cidr}"
  vpc_zone = "${var.vpc_zone}"
}

resource "aws_sqs_queue" "asg_queue" {
  name = "${var.vpc_name}-asg-queue"
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"${var.vpc_name}-asg-enqueue\",\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"arn:aws:iam::${data.terraform_remote_state.global.aws_account_id}:root\"},\"Action\":\"SQS:SendMessage\",\"Resource\":\"arn:aws:sqs:${data.terraform_remote_state.global.aws_region}:${data.terraform_remote_state.global.aws_account_id}:${var.vpc_name}-asg-queue\"}]}"
}

output "igw" {
  value = "${module.vpc.igw}"
}

output "vpc_zone" {
  value = "${module.vpc.vpc_zone}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_net16" {
  value = "${join(".",concat(element(split(".",module.vpc.vpc_cidr),0),element(split(".",module.vpc.vpc_cidr),1)))}"
}

output "asg_id" {
  value = "${aws_sqs_queue.asg_queue.id}"
}

output "asg_arn" {
  value = "${aws_sqs_queue.asg_queue.arn}"
}

output "zone_id" {
  value = "${module.vpc.zone_id}"
}
