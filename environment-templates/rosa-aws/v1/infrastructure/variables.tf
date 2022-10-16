####### AWS Configuration #####
#variable "region" {
#  description = "The region to deploy the cluster in, e.g: us-west-2."
#  default     = "eu-west-1"
#}
#
#variable "key_name" {
#  description = "The name of the key to user for ssh access, e.g: consul-cluster"
#  default     = "openshift-admin"
#}
#
variable "tenancy" {
  description = "Amazon EC2 instances tenancy type, default/dedicated"
  default     = "default"
}
#
#variable "access_key_id" {
#  type        = string
#  description = "Access Key ID for the AWS account"
#}
#
#variable "secret_access_key" {
#  type        = string
#  description = "Secret Access Key for the AWS account"
#}
#
##############################
# New Network
##############################
#variable "vpc_cidr" {
#  description = "The CIDR block for the VPC, e.g: 10.0.0.0/16"
#  default     = "10.42.0.0/16"
#}
#
#variable "master_subnet_cidr1" {
##  default = "10.42.0.0/20"
#}
#
#variable "master_subnet_cidr2" {
#  default = "10.42.16.0/20"
#}
#
#variable "master_subnet_cidr3" {
#  default = "10.42.32.0/20"
#}
#
#variable "worker_subnet_cidr1" {
#  default = "10.42.128.0/20"
#}
#
#variable "worker_subnet_cidr2" {
#  default = "10.42.144.0/20"
#}
#
#variable "worker_subnet_cidr3" {
#  default = "10.42.160.0/20"
#}
##############################
#
#variable "cluster_name" {
#  default = "my-ocp"
#}
#
#
## Enter the number of availability zones the cluster is to be deployed, default is single zone deployment.
#variable "az" {
#  description = "single_zone / multi_zone"
#  default     = "single_zone"
#}
#
###################################
## New Openshift Cluster Variables
###################################
#variable "worker_instance_type" {
#  type    = string
#  default = "m5.4xlarge"
#}
#
#variable "worker_instance_volume_iops" {
#  type    = number
#  default = 2000
#}
#
#variable "worker_instance_volume_size" {
#  type    = number
#  default = 300
#}
#
#variable "worker_instance_volume_type" {
#  type    = string
#  default = "io1"
#}
#
#variable "worker_replica_count" {
#  type    = number
#  default = 3
#}
#
#variable "master_instance_type" {
#  type    = string
#  default = "m5.2xlarge"
#}
#
#variable "master_instance_volume_iops" {
#  type    = number
#  default = 4000
#}
#
#variable "master_instance_volume_size" {
#  type    = number
#  default = 300
#}
#
#variable "master_instance_volume_type" {
#  type    = string
#  default = "io1"
#}
#
#variable "master_replica_count" {
#  type    = number
#  default = 3
#}
#
#variable "cluster_network_cidr" {
#  type    = string
#  default = "10.128.0.0/14"
#}
#
#variable "cluster_network_host_prefix" {
#  type    = number
#  default = 23
#}
#
#variable "service_network_cidr" {
#  type    = string
#  default = "172.30.0.0/16"
#}
#
#variable "private_cluster" {
#  type        = bool
#  description = "Endpoints should resolve to Private IPs"
#  default     = false
#}
#
#variable "openshift_pull_secret_file_path" {
#  type = string
#}
#
#variable "public_ssh_key" {
#  type = string
#}
#
#variable "base_domain" {
#  type = string
#}
#
#variable "openshift_username" {
#  type = string
#}
#
#variable "openshift_password" {
#  type = string
#}
#
##########################################################
variable "openshift_version" {
  description = "Version >= 4.6.27"
  default     = "4.11.5"
}

