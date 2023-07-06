data "terraform_remote_state" "platform" {
  backend   = "s3"
  workspace = terraform.workspace

  config = {
    bucket         = "terraform-demo-remote-state"
    key            = "platform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfstate"
  }
}

data "aws_ami" "amazon2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2*-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
    filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
      name   = "virtualization-type"
      values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

data "http" "ip" {
  url = "https://ifconfig.me"
}

