resource "aws_eks_cluster" "setheryops_eks_cluster" {
  name     = "setheryops_eks"
  role_arn = aws_iam_role.setheryops_eks_role.arn
  version  = "1.18"

  vpc_config {
    subnet_ids = [module.vpc_setheryops.public_subnets[0], module.vpc_setheryops.public_subnets[1], module.vpc_setheryops.public_subnets[2]]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.setheryops_eks_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.setheryops_eks_AmazonEKSVPCResourceController,
  ]
}



resource "aws_eks_node_group" "setheryops_eks_node_group" {
  cluster_name    = aws_eks_cluster.setheryops_eks_cluster.name
  node_group_name = "setheryops_eks"
  node_role_arn   = aws_iam_role.setheryops_eks_role.arn
  subnet_ids      = [module.vpc_setheryops.public_subnets[0], module.vpc_setheryops.public_subnets[1], module.vpc_setheryops.public_subnets[2]]
  instance_types  = ["t3.small"]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.setheryops_eks_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.setheryops_eks_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.setheryops_eks_AmazonEC2ContainerRegistryReadOnly,
  ]
}
