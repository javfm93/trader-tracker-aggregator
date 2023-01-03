module "ecr-repository-name-parameter" {
  source = "git::https://@github.com/javfm93/infrastructure-aws-terraform.git//src/storage/use-cases/create-parameter"
  name   = "/${var.app_name}/infrastructure/ecr/repository-name"
  value  = module.create-new-backend.ecr-repository
}
