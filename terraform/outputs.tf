output "node_ip" {
  value = "${aws_instance.main.public_ip}"
}
