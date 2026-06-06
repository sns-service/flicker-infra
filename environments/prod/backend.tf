terraform {
  required_version = ">= 1.6"

  backend "s3" {
    bucket         = "flicker-tfstate-637423170275"
    key            = "prod/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "flicker-tfstate-lock"
    encrypt        = true
  }
}