resource "cloudflare_record" "sandstorm_entry" {
  domain = "garajau.com.br"
  name = "sandstorm"
  value = "${aws_instance.main.public_ip}"
  type = "A"
}
