data "terraform_remote_state" "core" {
  backend = "s3"

  config = {
    bucket = "trader-tracker-infrastructure"
    key    = "core.tfstate"
    region = "eu-west-1"
  }
}

module "create-new-public-backend" {
  source           = "git::https://github.com/javfm93/trader-tracker-infrastructure.git//src/use-cases/create-new-backend"
  app_name         = var.app_name
  cluster_name     = var.cluster_name
  app_port         = var.app_port
  cluster_id       = data.terraform_remote_state.core.outputs.cluster_id
  desired_tasks    = 1
  region           = var.region
  ssm_parameters   = []
  vpc_id           = data.terraform_remote_state.core.outputs.vpc_id
  app_target_group = var.app_target_group
  alb              = data.terraform_remote_state.core.outputs.public_alb
  subnets_id       = data.terraform_remote_state.core.outputs.public_subnets_ids
  public_key_path  = local.public_key_path
}

locals {
  public_key_path = ".ssh/${var.cluster_name}-key_pair.pub"
}
