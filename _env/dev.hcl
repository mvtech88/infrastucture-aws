locals {

#  make false for the component not to deploy during bootstraping. 
    
    aws-eks-addon = "true"
    cert-manager = "true" 
    cert-manager-issuers = "true"
    external-dns = "true" 
    ingress-controller = "true"
    argocd = "true"
    kube-prometheus-stack = "true"

# Infrastructure Module used for the deployment using git tags.
    vpc-module = "vpc-v0.0.1"
    eks-module = "eks-v0.0.4"
    external-dns-module = "external-dns-v0.0.4"
    argocd-module = "argocd-v0.0.4"
    aws-eks-addons-module = "aws-eks-addons-v0.0.4"
    cert-manager-module = "cert-manager-v0.0.7"
    cert-manager-issuers-module = "cert-manager-issuers-v0.0.1"
    ingress-controller-module = "ingress-controller-v0.0.1"
    kube-prometheus-stack-module = "kube-prometheus-stack-v0.0.1"

# Helm versions used for the infra components name 
    argocd_helm_verion = "5.42.0"
    aws-ebs-csi_version = "v1.18.0-eksbuild.1"
    cert-manager_helm_version = "v1.12.0"
    cert-manager-issuers_helm_version = "0.2.5"
    external-dns_helm_version = "6.23.3"
    ingress-controller_helm_verion = "4.0.1"
    kube-prometheus-stack_helm_version = "48.2.2"



}
