

include "root" {
  path = find_in_parent_folders()
}

include "stage" {
  path           = "${get_terragrunt_dir()}/../../_env/stage.hcl"
  expose         = true
  merge_strategy = "no_merge"
}

terraform {
  source = "git::git@github.c/infrastucture-modules.git//vpc?ref=${include.stage.locals.vpc-module}"
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

inputs = {
  env             = include.env.locals.env
  azs             = ["us-east-1a", "us-east-1b"] 
  private_subnets = ["10.0.0.0/19", "10.0.32.0/19"]
  public_subnets  = ["10.0.64.0/19", "10.0.96.0/19"]

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/stage-demo"  = "owned"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"         = 1
    "kubernetes.io/cluster/stage-demo" = "owned"
  }
}
