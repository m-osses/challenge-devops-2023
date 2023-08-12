
## VPC EKS

data "aws_availability_zones" "available" {}

module "vpc_eks" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "eks-vpc"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

## VPC Aurora

module "vpc_database" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "database-vpc"

  cidr = "10.1.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets  = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]

  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_hostnames = true

}


## VPC Peering

resource "aws_vpc_peering_connection" "eks_database" {
  vpc_id      = module.vpc_eks.vpc_id
  peer_vpc_id = module.vpc_database.vpc_id
  auto_accept = true
}

resource "aws_vpc_peering_connection_options" "eks_database" {
  vpc_peering_connection_id = aws_vpc_peering_connection.eks_database.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}
