
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # Renamed in v20+
  name                   = local.name
  endpoint_public_access = true

  # Add-ons: use new conflict arguments
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

  # Networking
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # Managed node groups (defaults applied per group)
  eks_managed_node_groups = {
    amc-cluster-wg = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      # Apply your previous defaults here, per group:
      ami_type        = "AL2_x86_64"
      instance_types  = ["t2.micro"]

      # This replaces the old "attach_cluster_primary_security_group = true"
      # behavior in v21+, which is handled automatically. If you need extra SGs,
      # use additional security group IDs at the cluster or node level via
      # module inputs documented in v21.x.
      capacity_type   = "ON_DEMAND"

      tags = {
        ExtraTag = "helloworld"
      }
    }
  }

  tags = local.tags
}
 

