locals {
  userdata =<<EOF
#!/bin/sh
# Install k3s
curl -sfL https://get.k3s.io | sh -


# Install Waypoint
yum install -y yum-utils shadow-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install waypoint

EOF
}