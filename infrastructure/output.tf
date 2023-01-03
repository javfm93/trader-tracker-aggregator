output "elb" {
  value = data.terraform_remote_state.core.outputs.elb_dns_name
}

output "ecr-repository" {
  value = module.create-new-backend.ecr-repository
}
