#Go here for latest info on this module:  https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/
module "vpc_setheryops" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "2.58.0"
  name            = "setheryops"
  cidr            = "201.201.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["201.201.1.0/24", "201.201.2.0/24", "201.201.3.0/24"]
  public_subnets  = ["201.201.11.0/24", "201.201.12.0/24", "201.201.13.0/24"]
  #database_subnets    = ["201.201.21.0/24", "201.201.22.0/24", "201.201.23.0/24"]
  #elasticache_subnets = ["201.201.31.0/24", "201.201.32.0/24", "201.201.33.0/24"]
  #redshift_subnets    = ["201.201.41.0/24", "201.201.42.0/24", "201.201.43.0/24"]
  #create_database_subnet_group = true
  enable_nat_gateway = true
  #enable_vpn_gateway = true
  #enable_s3_endpoint       = true
  #enable_dynamodb_endpoint = true
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_dhcp_options  = true

  tags = {
    Environment = "setheryops"
    Label       = "ManagedByTerraform"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/setheryops_eks" = "shared"
  }

}

data "aws_subnet_ids" "public" {
  vpc_id = "${module.vpc_setheryops.vpc_id}"
}

data "aws_subnet_ids" "private" {
  vpc_id = "${module.vpc_setheryops.vpc_id}"
}
