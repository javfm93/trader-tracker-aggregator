data "terraform_remote_state" "core" {
  backend = "s3"

  config = {
    bucket = "trader-tracker"
    key    = "infrastructure/core.tfstate"
    region = "eu-west-1"
  }
}

module "create-new-backend" {
  source         = "git::https://github.com/javfm93/trader-tracker-infrastructure.git//src/use-cases/create-new-backend"
  app_name       = var.app_name
  app_port       = var.app_port
  cluster_id     = data.terraform_remote_state.core.outputs.cluster_id
  desired_tasks  = 1
  elb_name       = data.terraform_remote_state.core.outputs.elb_name
  region         = var.region
  ssm_parameters = []
  vpc_id         = data.terraform_remote_state.core.outputs.vpc_id
}
