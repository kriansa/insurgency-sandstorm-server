resource "aws_cloudwatch_log_group" "main" {
  name = "MirroringService-Logs"

  tags {
    ServiceType = "Game"
    ServiceName = "SandstormServer"
  }
}

# Autoscaling groups template:
# https://github.com/azavea/terraform-aws-ecs-cluster/blob/develop/main.tf
