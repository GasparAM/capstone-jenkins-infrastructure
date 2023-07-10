variable "ingress_ips" {}

variable "cidr_block_vpc" {}

variable "eip" {}

variable "tags" {}

variable "ebs_block" {}

locals {
  subnetcalc = cidrsubnets(var.cidr_block_vpc, 8, 8)
  subnets_public = {
    "public-a" = {
      cidr_block        = local.subnetcalc[0]
      availability_zone = "eu-north-1a"
    }
    "public-b" = {
      cidr_block = local.subnetcalc[1]
      availability_zone = "eu-north-1b"
    }
  }
}