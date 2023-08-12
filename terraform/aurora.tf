module "cluster_aurora" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name           = "aurora-db-postgres-14"
  engine         = "aurora-postgresql"
  engine_version = "14.5"
  instance_class = "db.t3.medium"
  instances = {
    one = {}
    2 = {
      instance_class = "db.t3.medium"
    }
  }
  autoscaling_enabled      = true
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 5

  vpc_id                 = module.vpc_database.vpc_id
  create_db_subnet_group = true
  subnets                = module.vpc_database.private_subnets

  security_group_rules = {
    ex1_ingress = {
      cidr_blocks = [module.vpc_eks.private_subnets_cidr_blocks]
    }
    ex1_ingress = {
      source_security_group_id = module.eks.node_security_group_id
    }
  }

  master_username     = "root"
  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = {
    Terraform = "true"
  }
}
