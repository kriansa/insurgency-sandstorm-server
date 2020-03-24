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
  public_key = var.main_public_ssh_key
}

data "template_cloudinit_config" "ec2_cloudinit" {
  gzip = false
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = file("${path.module}/install_ansible.sh")
  }
}

resource "aws_spot_instance_request" "main" {
  ami           = data.aws_ami.amazon_linux.id
  key_name      = aws_key_pair.main.key_name
  instance_type = "c5.large"

  # The role used for this EC2
  iam_instance_profile = aws_iam_instance_profile.ec2_sandstorm.name

  # cloud-init data to configure the instance
  user_data_base64 = data.template_cloudinit_config.ec2_cloudinit.rendered

  # Networking
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_default_security_group.main.id,
    aws_security_group.allow_sandstorm_traffic_from_internet.id,
    aws_security_group.allow_ssh_from_admin.id,
  ]

  # Spot attributes
  spot_type = "one-time"
  wait_for_fulfillment = true

  tags = {
    Name        = "Sandstorm server"
    ServiceType = "Game"
    ServiceName = "SandstormServer"
  }

	# Wait then start provisioning
	provisioner "file" {
		source = "${path.root}/../../build/playbook.run"
		destination = "/home/ec2-user/playbook.run"
		connection {
			type = "ssh"
			user = "ec2-user"
			host = self.public_ip
		}
	}
}
