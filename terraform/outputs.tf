#################
# VPC
#################
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_setheryops.vpc_id
}

output "setheryops_vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc_setheryops.vpc_cidr_block
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc_setheryops.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc_setheryops.public_subnets
}


# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc_setheryops.nat_public_ips
}

output "availability_zones" {
  description = "List of availability_zones available for the VPC"
  value       = module.vpc_setheryops.azs
}


#################
# EKS CLUSTER
#################
output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = aws_eks_cluster.setheryops_eks_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.setheryops_eks_cluster.certificate_authority[0].data
}
