module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name                   = local.name
  endpoint_public_access = true

  # Explicitly set K8s version (you are currently hitting 1.34)
  kubernetes_version     = "1.34"

  # *** Use AL2023 for 1.34 ***
  eks_managed_node_groups = {
    amc-cluster-wg = {
      min_size      = 1
      max_size      = 2
      desired_size  = 1

      ami_type       = "AL2023_x86_64_STANDARD"  # or ARM_64 if Graviton
      instance_types = ["t2.micro"]
      capacity_type  = "ON_DEMAND"

      tags = { ExtraTag = "helloworld" }
    }
  }

  addons = {
    coredns = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }
    kube-proxy = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }
    vpc-cni = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  tags = local.tags
}
