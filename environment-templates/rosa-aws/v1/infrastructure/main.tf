provider "aws" {
  region     = var.environment.inputs.egion
  access_key = var.environment.inputs.access_key_id
  secret_key = var.environment.inputs.secret_access_key
}

data "aws_availability_zones" "azs" {}

locals {
  installer_workspace = "${path.root}/installer-files"
  availability_zone1  = var.availability_zone1 == "" ? data.aws_availability_zones.azs.names[0] : var.availability_zone1
  availability_zone2  = var.environment.inputs.az == "multi_zone" && var.availability_zone2 == "" ? data.aws_availability_zones.azs.names[1] : var.availability_zone2
  availability_zone3  = var.environment.inputs.az == "multi_zone" && var.availability_zone3 == "" ? data.aws_availability_zones.azs.names[2] : var.availability_zone3
  vpc_id              = var.vpc_id
  master_subnet1_id   = var.environment.inputs.master_subnet1_id
  master_subnet2_id   = var.environment.inputs.master_subnet2_id
  master_subnet3_id   = var.environment.inputs.master_subnet3_id
  worker_subnet1_id   = var.environment.inputs.worker_subnet1_id
  worker_subnet2_id   = var.environment.inputs.worker_subnet2_id
  worker_subnet3_id   = var.environment.inputs.worker_subnet3_id
  single_zone_subnets = [local.worker_subnet1_id]
  multi_zone_subnets  = [local.worker_subnet1_id, local.worker_subnet2_id, local.worker_subnet3_id]
  openshift_api       = ""
  openshift_username  = var.environment.inputs.openshift_username
  openshift_password  = var.environment.inputs.openshift_password
  openshift_token     = var.environment.inputs.openshift_token
  cluster_type        = "selfmanaged"
}

resource "null_resource" "aws_configuration" {
  provisioner "local-exec" {
    command = "mkdir -p ~/.aws"
  }

  provisioner "local-exec" {
    command = <<EOF
echo '${data.template_file.aws_credentials.rendered}' > ~/.aws/credentials
echo '${data.template_file.aws_config.rendered}' > ~/.aws/config
EOF
  }
}

data "template_file" "aws_credentials" {
  template = <<-EOF
[default]
aws_access_key_id = ${var.access_key_id}
aws_secret_access_key = ${var.secret_access_key}
EOF
}

data "template_file" "aws_config" {
  template = <<-EOF
[default]
region = ${var.region}
EOF
}

#resource "null_resource" "permission_resource_validation" {
#  count = var.enable_permission_quota_check ? 1 : 0
#  provisioner "local-exec" {
#    command = <<EOF
#  chmod +x scripts/*.sh scripts/*.py
#  scripts/aws_permission_validation.sh ; if [ $? -ne 0 ] ; then echo \"Permission Verification Failed\" ; exit 1 ; fi
#  echo file | scripts/aws_resource_quota_validation.sh ; if [ $? -ne 0 ] ; then echo \"Resource Quota Validation Failed\" ; exit 1 ; fi
#  EOF
#  }
#  depends_on = [
#    null_resource.aws_configuration,
#  ]
#}

module "network" {
  count               = var.new_or_existing_vpc_subnet == "new" && var.existing_cluster == false ? 1 : 0
  source              = "./network"
  vpc_cidr            = var.environment.inputs.vpc_cidr
  network_tag_prefix  = var.environment.inputs.cluster_name
  tenancy             = var.tenancy
  master_subnet_cidr1 = var.environment.inputs.master_subnet_cidr1
  master_subnet_cidr2 = var.environment.inputs.master_subnet_cidr2
  master_subnet_cidr3 = var.environment.inputs.master_subnet_cidr3
  worker_subnet_cidr1 = var.environment.inputs.worker_subnet_cidr1
  worker_subnet_cidr2 = var.environment.inputs.worker_subnet_cidr2
  worker_subnet_cidr3 = var.environment.inputs.worker_subnet_cidr3
  az                  = var.environment.inputs.az
  availability_zone1  = local.availability_zone1
  availability_zone2  = local.availability_zone2
  availability_zone3  = local.availability_zone3

  depends_on = [
    null_resource.aws_configuration,
    null_resource.permission_resource_validation,
  ]
}

module "ocp" {
  source                          = "./ocp"
  openshift_installer_url         = "https://mirror.openshift.com/pub/openshift-v4/clients/ocp"
  multi_zone                      = var.az == "multi_zone" ? true : false
  cluster_name                    = var.environment.inputs.cluster_name
  base_domain                     = var.environment.inputs.base_domain
  region                          = var.environment.inputs.region
  availability_zone1              = local.availability_zone1
  availability_zone2              = local.availability_zone2
  availability_zone3              = local.availability_zone3
  worker_instance_type            = var.environment.inputs.worker_instance_type
  worker_instance_volume_iops     = var.environment.inputs.worker_instance_volume_iops
  worker_instance_volume_type     = var.environment.inputs.worker_instance_volume_type
  worker_instance_volume_size     = var.environment.inputs.worker_instance_volume_size
  worker_replica_count            = var.environment.inputs.worker_replica_count
  master_instance_type            = var.environment.inputsmaster_instance_type
  master_instance_volume_iops     = var.environment.inputs.master_instance_volume_iops
  master_instance_volume_type     = var.environment.inputs.master_instance_volume_type
  master_instance_volume_size     = var.environment.inputs.master_instance_volume_size
  master_replica_count            = var.environment.inputs.master_replica_count
  cluster_network_cidr            = var.environment.inputs.cluster_network_cidr
  cluster_network_host_prefix     = var.cluster_network_host_prefix
  machine_network_cidr            = var.vpc_cidr
  service_network_cidr            = var.service_network_cidr
  master_subnet1_id               = local.master_subnet1_id
  master_subnet2_id               = local.master_subnet2_id
  master_subnet3_id               = local.master_subnet3_id
  worker_subnet1_id               = local.worker_subnet1_id
  worker_subnet2_id               = local.worker_subnet2_id
  worker_subnet3_id               = local.worker_subnet3_id
  private_cluster                 = var.private_cluster
  openshift_pull_secret_file_path = var.openshift_pull_secret_file_path
  public_ssh_key                  = var.public_ssh_key
  enable_fips                     = var.enable_fips
  openshift_username              = var.openshift_username
  openshift_password              = var.openshift_password
  enable_autoscaler               = var.enable_autoscaler
  installer_workspace             = local.installer_workspace
  openshift_version               = var.openshift_version
  vpc_id                          = local.vpc_id

  depends_on = [
    module.network,
    null_resource.aws_configuration,
    null_resource.permission_resource_validation,
  ]
}

module "efs" {
  count                 = var.efs.enable ? 1 : 0
  source                = "./efs"
  installer_workspace   = local.installer_workspace
  cluster_name          = var.cluster_name
  openshift_api         = local.openshift_api
  openshift_username    = local.openshift_username
  openshift_password    = local.openshift_password
  openshift_token       = var.existing_openshift_token
  region                = var.region
  az                    = var.az
  vpc_id                = local.vpc_id
  aws_access_key_id     = var.access_key_id
  aws_secret_access_key = var.secret_access_key
  subnet_ids            = var.az == "multi_zone" ? [local.worker_subnet1_id , local.worker_subnet2_id , local.worker_subnet3_id ] : [local.worker_subnet1_id]
  depends_on = [
    module.ocp,
    module.network,
    null_resource.aws_configuration,
  ]
}

