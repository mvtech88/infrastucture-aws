locals {

# hell again  again ichanging file for testing again .
#  make false for the component not to deploy during bootstraping. 
    
    aws-eks-addon = "false"
    cert-manager = "false" 
    cert-manager-issuers = "false"
    external-dns = "false" 
    ingress-controller = "false"
    aws-lb-controller = "false"
    argocd = "false"
    kube-prometheus-stack = "false"
    argocd-imageupdater = "false"

# Infrastructure Module for the deployment.
    vpc-module = "vpc-v0.0.1"
    eks-module = "eks-v0.0.2"
    external-dns-module = "external-dns-v0.0.11"
    argocd-module = "argocd-v0.1.2"
    aws-eks-addons-module = "aws-eks-addons-v0.0.3"
    cert-manager-module = "cert-manager-v0.0.14"
    cert-manager-issuers-module = "cert-manager-issuers-v0.0.5"
    ingress-controller-module = "ingress-controller-v0.0.4"
    kube-prometheus-stack-module = "kube-prometheus-stack-v0.0.20"
    argocd-imageupdater-module = "argocd-imageupdater-v0.0.2"
    aws-lbc-module = "aws-lbc-v0.0.1"

# Helm versions used for the infra components.name 
    argocd_helm_verion = "5.42.0"
    argocd-imageup_helm_verion = "0.8.4"
    aws-ebs-csi_version = "v1.18.0-eksbuild.1"
    aws-lbc_helm_verion = "1.4.4"
    cert-manager_helm_version = "v1.12.0"
    cert-manager-issuers_helm_version = "0.2.5"
    external-dns_helm_version = "6.23.3"
    ingress-controller_helm_verion = "4.0.1"
    kube-prometheus-stack_helm_version = "48.2.2"



}
