
include "root" {
  path = find_in_parent_folders()
}

include "dev" {
  path           = "${get_terragrunt_dir()}/../../_env/dev.hcl"
  expose         = true
  merge_strategy = "no_merge"
}

terraform {
  source = "git::git@github.com:mvtech88/infrastucture-modules.git//ingress-nginx?ref=${include.dev.locals.ingress-controller-module}"
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

  enable_ingress-controller      = include.dev.locals.ingress-controller
  ingress-controller_helm_verion = include.dev.locals.ingress-controller_helm_verion
}

dependency "eks" {
  config_path = "../eks"
 
  mock_outputs = {
    eks_name            = "demo"
    openid_provider_arn = "arn:aws:iam::123456789012:oidc-provider"
  }
}


dependency "cert-manager-issuers" {
  config_path = "../cert-manager-issuers"
  skip_outputs = true
}

generate "helm_provider" {
  path      = "helm-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

data "aws_eks_cluster" "eks" {
    name = var.eks_name
}

data "aws_eks_cluster_auth" "eks" {
    name = var.eks_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}
EOF
}
