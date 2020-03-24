output "node_ip" {
  value = aws_spot_instance_request.main.public_ip
}
