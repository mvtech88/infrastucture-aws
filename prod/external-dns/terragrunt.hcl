#terraform {
#  source = "git::git@github.com:Mohit-Verma-1688/infrastucture-modules.git//external-dns?ref=external-dns-v0.0.11"
#}

include "root" {
  path = find_in_parent_folders()
}

include "prod" {
  path           = "${get_terragrunt_dir()}/../../_env/prod.hcl"
  expose         = true
  merge_strategy = "no_merge"
}

terraform {
  source = "git::git@github.com:Mohit-Verma-1688/infrastucture-modules.git//external-dns?ref=${include.prod.locals.external-dns-module}"
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

  enable_external-dns      = include.prod.locals.external-dns
  external-dns_helm_version = include.prod.locals.external-dns_helm_version
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
