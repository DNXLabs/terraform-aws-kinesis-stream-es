provider "aws" {
  version = "~> 2.69"
  region  = var.aws_region
}

provider "archive" {
  version = "~> 1.3"
}