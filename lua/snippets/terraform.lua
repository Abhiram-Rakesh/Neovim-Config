local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

ls.add_snippets('terraform', {

  -- provider block
  s('provider', fmt([[
provider "{}" {{
  {}
}}
]], { i(1, 'aws'), i(2) })),

  -- AWS provider
  s('provider-aws', fmt([[
provider "aws" {{
  region  = var.aws_region
  profile = "{}"
}}
]], { i(1, 'default') })),

  -- GCP provider
  s('provider-gcp', fmt([[
provider "google" {{
  project = var.project_id
  region  = var.region
  zone    = var.zone
}}
]], {})),

  -- Azure provider
  s('provider-azurerm', fmt([[
provider "azurerm" {{
  features {{}}
  subscription_id = var.subscription_id
}}
]], {})),

  -- resource block
  s('resource', fmt([[
resource "{}" "{}" {{
  {}
}}
]], { i(1, 'aws_instance'), i(2, 'this'), i(3) })),

  -- variable block
  s('variable', fmt([[
variable "{}" {{
  description = "{}"
  type        = {}
  default     = {}
}}
]], { i(1, 'name'), i(2, 'description'), i(3, 'string'), i(4, 'null') })),

  -- output block
  s('output', fmt([[
output "{}" {{
  description = "{}"
  value       = {}
}}
]], { i(1, 'name'), i(2, 'description'), i(3, 'null') })),

  -- locals block
  s('locals', fmt([[
locals {{
  {} = {}
}}
]], { i(1, 'name'), i(2, 'value') })),

  -- data source block
  s('data', fmt([[
data "{}" "{}" {{
  {}
}}
]], { i(1, 'aws_ami'), i(2, 'this'), i(3) })),

  -- module block
  s('module', fmt([[
module "{}" {{
  source = "{}"

  {}
}}
]], { i(1, 'name'), i(2, './modules/name'), i(3) })),

  -- S3 backend
  s('backend-s3', fmt([[
terraform {{
  backend "s3" {{
    bucket         = "{}"
    key            = "{}"
    region         = "{}"
    dynamodb_table = "{}"
    encrypt        = true
  }}
}}
]], { i(1, 'my-tfstate-bucket'), i(2, 'env/terraform.tfstate'), i(3, 'us-east-1'), i(4, 'terraform-locks') })),

  -- GCS backend
  s('backend-gcs', fmt([[
terraform {{
  backend "gcs" {{
    bucket = "{}"
    prefix = "{}"
  }}
}}
]], { i(1, 'my-tfstate-bucket'), i(2, 'env/terraform') })),

  -- Azure backend
  s('backend-azurerm', fmt([[
terraform {{
  backend "azurerm" {{
    resource_group_name  = "{}"
    storage_account_name = "{}"
    container_name       = "{}"
    key                  = "{}"
  }}
}}
]], { i(1, 'tfstate-rg'), i(2, 'tfstatestorage'), i(3, 'tfstate'), i(4, 'env/terraform.tfstate') })),

  -- terraform required_providers block
  s('required-providers', fmt([[
terraform {{
  required_version = ">= {}"

  required_providers {{
    {} = {{
      source  = "{}"
      version = "~> {}"
    }}
  }}
}}
]], { i(1, '1.5.0'), i(2, 'aws'), i(3, 'hashicorp/aws'), i(4, '5.0') })),

  -- EC2 instance
  s('aws-ec2', fmt([[
resource "aws_instance" "{}" {{
  ami           = data.aws_ami.{}.id
  instance_type = "{}"

  subnet_id              = {}
  vpc_security_group_ids = [{}]

  tags = merge(local.common_tags, {{
    Name = "{}"
  }})
}}
]], { i(1, 'this'), i(2, 'amazon_linux'), i(3, 't3.micro'), i(4, 'var.subnet_id'), i(5, 'aws_security_group.this.id'), i(6, 'my-instance') })),

  -- S3 bucket
  s('aws-s3', fmt([[
resource "aws_s3_bucket" "{}" {{
  bucket = "{}"

  tags = merge(local.common_tags, {{
    Name = "{}"
  }})
}}

resource "aws_s3_bucket_versioning" "{}_versioning" {{
  bucket = aws_s3_bucket.{}.id
  versioning_configuration {{
    status = "Enabled"
  }}
}}
]], { i(1, 'this'), i(2, 'my-bucket'), i(3, 'my-bucket'), i(4, 'this'), i(5, 'this') })),

  -- Security group
  s('aws-sg', fmt([[
resource "aws_security_group" "{}" {{
  name        = "{}"
  description = "{}"
  vpc_id      = {}

  ingress {{
    from_port   = {}
    to_port     = {}
    protocol    = "tcp"
    cidr_blocks = [{}]
  }}

  egress {{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }}

  tags = merge(local.common_tags, {{
    Name = "{}"
  }})
}}
]], { i(1, 'this'), i(2, 'my-sg'), i(3, 'My security group'), i(4, 'var.vpc_id'), i(5, '443'), i(6, '443'), i(7, '"0.0.0.0/0"'), i(8, 'my-sg') })),

  -- IAM role
  s('aws-iam-role', fmt([[
resource "aws_iam_role" "{}" {{
  name = "{}"

  assume_role_policy = jsonencode({{
    Version = "2012-10-17"
    Statement = [
      {{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {{
          Service = "{}"
        }}
      }},
    ]
  }})

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'my-role'), i(3, 'ec2.amazonaws.com') })),

  -- EKS cluster
  s('aws-eks', fmt([[
resource "aws_eks_cluster" "{}" {{
  name     = "{}"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "{}"

  vpc_config {{
    subnet_ids              = {}
    endpoint_private_access = true
    endpoint_public_access  = false
  }}

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'my-cluster'), i(3, '1.29'), i(4, 'var.subnet_ids') })),

  -- RDS instance
  s('aws-rds', fmt([[
resource "aws_db_instance" "{}" {{
  identifier        = "{}"
  engine            = "{}"
  engine_version    = "{}"
  instance_class    = "{}"
  allocated_storage = {}

  db_name  = "{}"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.{}.name
  vpc_security_group_ids = [aws_security_group.{}.id]

  skip_final_snapshot = {}
  multi_az            = {}

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'my-db'), i(3, 'postgres'), i(4, '15.4'), i(5, 'db.t3.micro'), i(6, '20'), i(7, 'mydb'), i(8, 'this'), i(9, 'this'), i(10, 'true'), i(11, 'false') })),

  -- VPC
  s('aws-vpc', fmt([[
resource "aws_vpc" "{}" {{
  cidr_block           = "{}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {{
    Name = "{}"
  }})
}}
]], { i(1, 'this'), i(2, '10.0.0.0/16'), i(3, 'my-vpc') })),

  -- common_tags locals
  s('common-tags', fmt([[
locals {{
  common_tags = {{
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
    Owner       = "{}"
  }}
}}
]], { i(1, 'team') })),

})
