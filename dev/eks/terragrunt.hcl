
include "root" {
  path = find_in_parent_folders()
}

include "dev" {
  path           = "${get_terragrunt_dir()}/../../_env/dev.hcl"
  expose         = true
  merge_strategy = "no_merge"
}


terraform {
  source = "git@github.com:Mohit-Verma-1688/infrastucture-modules.git//eks?ref=${include.dev.locals.eks-module}"
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

inputs = {
  eks_version = "1.26"
  env         = include.env.locals.env
  eks_name    = "demo"
  subnet_ids  = dependency.vpc.outputs.private_subnet_ids

  node_groups = {
    general = {
      capacity_type  = "ON_DEMAND"
      instance_types = ["t3.large"]
      scaling_config = {
        desired_size = 1
        max_size     = 10
        min_size     = 0
      }
    }
  }
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    private_subnet_ids = ["subnet-1234", "subnet-5678"]
  }
}
