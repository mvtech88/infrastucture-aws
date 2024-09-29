

include "root" {
  path = find_in_parent_folders()
}

include "prod" {
  path           = "${get_terragrunt_dir()}/../../_env/prod.hcl"
  expose         = true
  merge_strategy = "no_merge"
}

terraform {
  source = "git::git@github.com:infrastucture-modules.git//argocd?ref=${include.prod.locals.argocd-module}"
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

  enable_argocd      = include.prod.locals.argocd
  argocd_helm_verion = include.prod.locals.argocd_helm_verion
  aws_ssm_key_name = "argocd-terraform-key"
  private_git_repo = "git@github.com:Mo*****/applications.git"
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    eks_name            = "demo"
    openid_provider_arn = "arn:aws:iam::123456789012:oidc-provider"
  }
}


dependency "external-dns" {
  config_path = "../external-dns"
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

generate "kubernetes_provider" {
  path      = "k8s-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

data "aws_eks_cluster" "eks1" {
    name = var.eks_name
}

data "aws_eks_cluster_auth" "eks1" {
    name = var.eks_name
}

provider "kubernetes" {
    host                   = data.aws_eks_cluster.eks1.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks1.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks1.token
}
EOF
}

