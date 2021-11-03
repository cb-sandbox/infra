variable "region" {
  default = "us-east-1"
}

########
## EKS ##
########

variable "cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  type        = string
  default     = "ikurtz_cbdemos_tf_eks_sandbox"
}

###############
## Node Groups ##
###############

variable "name_prefix" {
  description = "Name prefix for worker node security groups"
  type        = string
  default     = "ikurtz"
}

variable "node_group_1_name" {
  description = "Name node group 1 managed by EKS"
  type        = string
  default     = "ikurtz_cbdemos_tf_eks_ng_1"
}

variable "node_group_2_name" {
  description = "Name node groups managed by EKS"
  type        = string
  default     = "ikurtz_cbdemos_tf_eks_ng_2"
}

variable "instance_types" {
  description = "Name node groups managed by EKS"
  type        = string
  default     = "m5.xlarge"
}

########
## VPC ##
########

variable "vpc_name" {
  description = "Name for VPC"
  type        = string
  default     = "ikurtz_cbdemos_sandbox_tf_vpc"
}

variable "vpc_cidr" {
  description = "IP CIDR range for VPC"
  type        = string
  default     = "172.16.0.0/16"
}

variable "private_subnets" {
  description = "A list of subnets to place the EKS cluster and workers within."
  type        = list(string)
  default     = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
}

variable "public_subnets" {
  description = "A list of subnets to place the EKS cluster and workers within."
  type        = list(string)
  default     = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
}
