
terraform {
  required_version = "~> 0.10"

  backend "s3" {
    region = "ap-northeast-1"
    dynamodb_table = "TerraformLockState"
  }
}

provider "aws" {
  region = "${var.region}"
}

