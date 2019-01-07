# Get the latest AMI for ECS
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"]
}

resource "aws_key_pair" "main" {
  key_name   = "main-deployer-key"
  public_key = "${var.main_public_ssh_key}"
}

resource "aws_instance" "main" {
  ami = "${data.aws_ami.amazon_linux.id}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.main.key_name}"

  # The role used for this EC2
  iam_instance_profile = "${aws_iam_instance_profile.ec2_sandstorm.name}"

  # Networking
  subnet_id = "${aws_subnet.main.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = [
    "${aws_default_security_group.main.id}",
    "${aws_security_group.allow_sandstorm_traffic_from_internet.id}",
    "${aws_security_group.allow_ssh_from_admin.id}"
  ]

  tags {
    Name = "Sandstorm server"
    ServiceType = "Game"
    ServiceName = "SandstormServer"
  }

  # Wait then start provisioning
  provisioner local-exec {
    command = "../bin/provision ${self.public_ip} ec2-user"
  }
}
