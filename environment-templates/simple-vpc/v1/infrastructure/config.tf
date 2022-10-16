/*
This file is managed by AWS Proton. Any changes made directly to this file will be overwritten the next time AWS Proton performs an update.

To manage this resource, see AWS Proton Resource: arn:aws:proton:eu-west-1:823983898304:environment/my-vpc-4-a-project

If the resource is no longer accessible within AWS Proton, it may have been deleted and may require manual cleanup.
*/

/*
This file is managed by AWS Proton. Any changes made directly to this file will be overwritten the next time AWS Proton performs an update.

To manage this resource, see AWS Proton Resource: arn:aws:proton:eu-west-1:823983898304:environment/simple-vpc-4-my-project

If the resource is no longer accessible within AWS Proton, it may have been deleted and may require manual cleanup.
*/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.4.0"
    }
  }

  backend "s3" {}
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
  default_tags {
   tags = {
     Environment = "simple-vpc-template implantation example issued by Proton through the Sopra Steria Container and Orchestration Services with AWS"
     Owner       = "Renaud FLEURY"
     Project     = var.environment.inputs.project_name
   }
  }
}
