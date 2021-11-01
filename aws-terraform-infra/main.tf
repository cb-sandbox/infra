provider "aws" {
  region = var.region
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = var.cluster_name
  cluster_version = "1.21"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets

  tags = {
    "owner" = "ikurtz"
    "cb-owner" = "cloudbees-sa"
  }

  node_groups_defaults = {
    ami_type = "AL2_x86_64"
    root_volume_type = "gp3"
    disk_size = "32"
  }

  worker_additional_security_group_ids = [aws_security_group.cbdemos_all_ng_mgmt.id]

  # Node groups (using Launch Configurations)

  node_groups = [
    {
      name                          = var.node_group_1_name
      instance_types                = var.instance_types
      additional_userdata           = "EKS managed nodes for CloudBees SDA"
      desired_capacity              = 2
      additional_security_group_ids = [aws_security_group.cbdemos_tf_eks_ng_mgmt_1.id]
    },
    {
      name                          = var.node_group_2_name
      instance_types                = var.instance_types
      additional_userdata           = "EKS managed nodes for CloudBees SDA"
      additional_security_group_ids = [aws_security_group.cbdemos_tf_eks_ng_mgmt_2.id]
      desired_capacity              = 1
    },
  ]
}

#############
# Kubernetes
#############

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
################################################################################
# Supporting resources
################################################################################

resource "aws_security_group" "cbdemos_tf_eks_ng_mgmt_1" {
  name_prefix = var.name_prefix
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}

resource "aws_security_group" "cbdemos_tf_eks_ng_mgmt_2" {
  name_prefix = var.name_prefix
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "192.168.0.0/16",
    ]
  }
}

resource "aws_security_group" "cbdemos_all_ng_mgmt" {
  name_prefix = var.name_prefix
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}

#########
# VPC
#########

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.66.0"

  name                 = var.vpc_name
  cidr                 = var.vpc_cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}