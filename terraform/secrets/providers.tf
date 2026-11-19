terraform {
  required_version = "~> 1.17"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 6.73" }

  }
}

provider "aws" {
  region = "eu-north-1"
  default_tags {
    tags = { Project = "fitnessbuddy", ManagedBy = "terraform" }
  }

}