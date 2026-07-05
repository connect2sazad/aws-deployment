terraform {

  # fix the terraform core version
  required_version = ">= 1.15.7"

  # fix the aws provider version
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # backend config to store terraform state file in s3 bucket and locking the state using same s3 bucket
  backend "s3" {
    bucket       = "terraform-tfstate-bkt1"
    region       = "ap-south-1"
    key          = "terraform.tfstate"
    use_lockfile = true
  }
}