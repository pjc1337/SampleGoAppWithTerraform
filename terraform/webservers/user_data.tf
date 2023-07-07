locals {
  user_data_rhel = <<EOF
#!/bin/sh
# Install k3s pre-reqs
amazon-linux-extras install docker -y
yum install -y container-selinux
yum install -y https://rpm.rancher.io/k3s/stable/common/centos/9/noarch/

# Install k3s
curl -sfL https://get.k3s.io | sh -

# Install Waypoint
yum install -y yum-utils shadow-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install waypoint

EOF
  user_data_deb  = <<EOF
#!/bin/sh
# Update to latest packages
apt update && apt upgrade -y
# Install Docker
apt install docker.io -y
usermod -aG docker ubuntu

# Install Waypoint
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get update && apt-get install waypoint -y
EOF
}