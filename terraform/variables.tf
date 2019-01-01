variable instance_type {
  type = "string"
  description = "The type of the instance to be launched for ECS"
}

variable admin_ips {
  type = "list"
  description = "The IP list that should have SSH enabled on the instances"
}

variable main_public_ssh_key {
  type = "string"
  description = "The public SSH key used for using with AWS CodeCommit and EC2"
}
