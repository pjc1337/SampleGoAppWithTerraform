resource "aws_instance" "web" {
  count                       = local.web_server_count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.web.id]
  subnet_id                   = data.terraform_remote_state.platform.outputs.public_subnets[count.index]
  key_name                    = aws_key_pair.key.key_name
  user_data                   = local.user_data_deb
  user_data_replace_on_change = true
  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    tags = {
      Name = "${local.env}-webserver-${format("%02d", count.index + 1)}"
      Env  = "${local.env}"
    }
  }

  tags = {
    Name = "${local.env}-webserver-${format("%02d", count.index + 1)}"
    Env  = "${local.env}"
  }
}

resource "aws_security_group" "web" {
  name        = "${local.env}-web"
  description = "Allow inbound traffic"
  vpc_id      = data.terraform_remote_state.platform.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${data.http.ip.response_body}/32"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.env}-web"
  }
}

resource "aws_eip" "web" {
  count    = local.web_server_count
  domain   = "vpc"
  instance = aws_instance.web[count.index].id
}

resource "aws_key_pair" "key" {
  key_name   = "web"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "tls_private_key" "ssh" {
  algorithm = "ED25519"
}
