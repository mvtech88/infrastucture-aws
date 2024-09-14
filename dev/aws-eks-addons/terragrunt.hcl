#terraform {
#  source = "git::git@github.com:Mohit-Verma-1688/infrastucture-modules.git//aws-eks-addons?ref=aws-eks-addons-v0.0.3"
#}

include "root" {
  path = find_in_parent_folders()
}

include "dev" {
  path           = "${get_terragrunt_dir()}/../../_env/dev.hcl"
  expose         = true
  merge_strategy = "no_merge"
}

terraform {
  source = "git::git@github.com:Mohit-Verma-1688/infrastucture-modules.git//aws-eks-addons?ref=${include.dev.locals.aws-eks-addons-module}"
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

inputs = {
  env      = include.env.locals.env
  eks_name = dependency.eks.outputs.eks_name
  openid_provider_arn = dependency.eks.outputs.openid_provider_arn

  enable_aws-eks-addon = include.dev.locals.aws-eks-addon
  aws-ebs-csi_version = include.dev.locals.aws-ebs-csi_version
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    eks_name            = "demo"
    openid_provider_arn = "arn:aws:iam::123456789012:oidc-provider"
  }
}

