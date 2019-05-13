variable admin_ips {
  type = "list"
  description = "The IP list that should have SSH enabled on the instances"
}

variable main_public_ssh_key {
  type = "string"
  description = "The public SSH key used for using with AWS CodeCommit and EC2"
}
