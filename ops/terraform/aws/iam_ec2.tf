resource "aws_iam_role" "ec2_sandstorm" {
  name        = "EC2SandstormServer"
  description = "Role to enable EC2 Sandstorm Server to use AWS resources"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

# Default policy for the Amazon EC2 Role for Amazon EC2 Container Service.
data "aws_iam_policy" "amazon_cloud_watch_agent_server" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "cw_admin_to_ec2_sandstorm" {
  role = aws_iam_role.ec2_sandstorm.name
  policy_arn = data.aws_iam_policy.amazon_cloud_watch_agent_server.arn
}

# Instance Profile is a abstraction to link a Role with an EC2 instance
# Other services such as ECS allows you to pass a Role directly on launch
resource "aws_iam_instance_profile" "ec2_sandstorm" {
  name = "EC2SandstormServer"
  role = aws_iam_role.ec2_sandstorm.name
}

