
include "root" {
  path = find_in_parent_folders()
}

include "dev" {
  path           = "${get_terragrunt_dir()}/../../_env/dev.hcl"
  expose         = true
  merge_strategy = "no_merge"
}

terraform {
  source = "git::git@github.com:mvtech88/infrastucture-modules.git//external-dns?ref=${include.dev.locals.external-dns-module}"
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

  enable_external-dns      = include.dev.locals.external-dns
  external-dns_helm_version = include.dev.locals.external-dns_helm_version
}


dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    eks_name            = "demo"
    openid_provider_arn = "arn:aws:iam::123456789012:oidc-provider"
  }
}

dependency "ingress-controller" {
  config_path = "../ingress-controller"
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
