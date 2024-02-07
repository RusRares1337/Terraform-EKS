provider "aws" {
    region = "eu-west-3"
}


variable vpc_cidr_block {}
variable private_subnet_cidr_block {}
variable public_subnet_cidr_block {}


module "myapp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = "myapp-vpc"
  cidr = var.vpc_cidr_block

  azs = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
  private_subnets = var.private_subnet_cidr_block
  public_subnets = var.public_subnet_cidr_block

  enable_nat_gateway = true
  enable_vpn_gateway = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }

}