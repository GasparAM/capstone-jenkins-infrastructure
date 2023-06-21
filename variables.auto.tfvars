cidr_block_vpc    = "10.1.0.0/16"
ebs_block = "vol-091a0af135ef94235"
# cidr_block_subnet = "10.0.1.0/24"
ingress_ips       = ["139.45.214.21/32", "0.0.0.0/0"]
tags = {
  Name    = "Terraform-test"
  Project = "2023_internship_yvn"
  Owner   = "gavetisyan"
}
