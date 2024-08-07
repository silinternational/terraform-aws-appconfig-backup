
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      version = ">=5.0.0, <6.0"
      source  = "hashicorp/aws"
    }
  }
}
