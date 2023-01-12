output "public_alb" {
  value = data.terraform_remote_state.core.outputs.public_alb.dns
}

output "ecr_repository" {
  value = module.create-new-public-backend.ecr-repository
}