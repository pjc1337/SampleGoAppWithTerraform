terraform {
  backend "s3" {
    bucket         = "terraform-demo-remote-state"
    key            = "webservers.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfstate"
  }
}
