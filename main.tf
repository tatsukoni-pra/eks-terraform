terraform {
  required_version = "1.11.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.90.1"
    }
  }
  backend "s3" {
    bucket  = "tatsukoni-tfstates"
    key     = "aws/eks/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "tatsukoni"
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "tatsukoni"
}
