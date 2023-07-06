output "public_ips" {
  value = aws_eip.web.*.public_ip
}