terraform {
  backend "s3" {
    bucket         = "terraform-demo-remote-state"
    key            = "platform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfstate"
  }
}
