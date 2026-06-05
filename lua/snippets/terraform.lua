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

  -- ── Core language blocks ──────────────────────────────────────────────

  -- terraform block (standalone, no backend)
  s('terraform', fmt([[
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

  -- moved block (TF 1.1+) — rename/move a resource without destroying it
  s('moved', fmt([[
moved {{
  from = {}
  to   = {}
}}
]], { i(1, 'aws_instance.old_name'), i(2, 'aws_instance.new_name') })),

  -- import block (TF 1.5+) — bring existing infra under Terraform management
  s('import', fmt([[
import {{
  id = "{}"
  to = {}
}}
]], { i(1, 'i-1234567890abcdef0'), i(2, 'aws_instance.this') })),

  -- check block (TF 1.5+) — post-apply assertions
  s('check', fmt([[
check "{}" {{
  data "{}" "{}" {{
    {}
  }}

  assert {{
    condition     = {}
    error_message = "{}"
  }}
}}
]], { i(1, 'check_name'), i(2, 'http'), i(3, 'health'), i(4), i(5, 'data.http.health.status_code == 200'), i(6, 'Health check failed.') })),

  -- removed block (TF 1.7+) — safely remove a resource from state without destroying
  s('removed', fmt([[
removed {{
  from = {}

  lifecycle {{
    destroy = {}
  }}
}}
]], { i(1, 'aws_instance.this'), i(2, 'false') })),

  -- ── Meta-arguments ────────────────────────────────────────────────────

  -- lifecycle block
  s('lifecycle', fmt([[
lifecycle {{
  create_before_destroy = {}
  prevent_destroy       = {}
  ignore_changes        = [{}]
}}
]], { i(1, 'true'), i(2, 'false'), i(3) })),

  -- lifecycle — ignore_changes only (most common use case)
  s('lifecycle-ignore', fmt([[
lifecycle {{
  ignore_changes = [{}]
}}
]], { i(1, 'tags, ami') })),

  -- lifecycle — prevent destroy (protect critical resources)
  s('lifecycle-prevent', fmt([[
lifecycle {{
  prevent_destroy = true
}}
]], {})),

  -- depends_on meta-argument
  s('depends-on', fmt([[
depends_on = [{}]
]], { i(1, 'aws_iam_role_policy_attachment.this') })),

  -- count meta-argument
  s('count', fmt([[
count = {}

  name = "${{}}"
]], { i(1, 'var.instance_count'), i(2, 'var.name}-${count.index') })),

  -- for_each resource pattern
  s('for-each', fmt([[
for_each = {}

  name = each.{}
]], { i(1, 'var.instances'), i(2, 'key') })),

  -- dynamic block
  s('dynamic', fmt([[
dynamic "{}" {{
  for_each = {}
  content {{
    {} = {}.value.{}
  }}
}}
]], { i(1, 'ingress'), i(2, 'var.ingress_rules'), i(3, 'from_port'), i(4, 'ingress'), i(5, 'from_port') })),

  -- ── Variable validation ───────────────────────────────────────────────

  -- variable with validation block
  s('variable-validation', fmt([[
variable "{}" {{
  description = "{}"
  type        = {}

  validation {{
    condition     = {}
    error_message = "{}"
  }}
}}
]], { i(1, 'environment'), i(2, 'Deployment environment'), i(3, 'string'), i(4, 'contains(["dev", "staging", "prod"], var.environment)'), i(5, 'Must be dev, staging, or prod.') })),

  -- precondition (inside resource/data lifecycle block, TF 1.2+)
  s('precondition', fmt([[
lifecycle {{
  precondition {{
    condition     = {}
    error_message = "{}"
  }}
}}
]], { i(1, 'var.instance_count > 0'), i(2, 'instance_count must be greater than 0.') })),

  -- postcondition (inside resource/data lifecycle block, TF 1.2+)
  s('postcondition', fmt([[
lifecycle {{
  postcondition {{
    condition     = {}
    error_message = "{}"
  }}
}}
]], { i(1, 'self.arn != ""'), i(2, 'Resource ARN must not be empty.') })),

  -- ── Additional backends ───────────────────────────────────────────────

  -- HCP Terraform (cloud block)
  s('backend-cloud', fmt([[
terraform {{
  cloud {{
    organization = "{}"

    workspaces {{
      name = "{}"
    }}
  }}
}}
]], { i(1, 'my-org'), i(2, 'my-workspace') })),

  -- Consul backend
  s('backend-consul', fmt([[
terraform {{
  backend "consul" {{
    address = "{}"
    scheme  = "https"
    path    = "{}"
  }}
}}
]], { i(1, 'consul.example.com:8500'), i(2, 'terraform/state') })),

  -- HTTP backend
  s('backend-http', fmt([[
terraform {{
  backend "http" {{
    address        = "{}"
    lock_address   = "{}/lock"
    unlock_address = "{}/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
  }}
}}
]], { i(1, 'https://my-backend.example.com/state'), i(2, 'https://my-backend.example.com/state'), i(3, 'https://my-backend.example.com/state') })),

  -- Local backend (useful for dev/testing)
  s('backend-local', fmt([[
terraform {{
  backend "local" {{
    path = "{}"
  }}
}}
]], { i(1, 'terraform.tfstate') })),

  -- ── Utility resources ─────────────────────────────────────────────────

  -- null_resource with triggers
  s('null-resource', fmt([[
resource "null_resource" "{}" {{
  triggers = {{
    {} = {}
  }}

  provisioner "local-exec" {{
    command = "{}"
  }}
}}
]], { i(1, 'this'), i(2, 'always_run'), i(3, 'timestamp()'), i(4, 'echo "running provisioner"') })),

  -- terraform_data (TF 1.4+ replacement for null_resource)
  s('terraform-data', fmt([[
resource "terraform_data" "{}" {{
  triggers_replace = [{}]

  provisioner "local-exec" {{
    command = "{}"
  }}
}}
]], { i(1, 'this'), i(2, 'var.trigger_value'), i(3, 'echo "triggered"') })),

  -- local_file
  s('local-file', fmt([[
resource "local_file" "{}" {{
  content  = {}
  filename = "{}"
}}
]], { i(1, 'this'), i(2, 'templatefile("${path.module}/templates/config.tpl", local.config_vars)'), i(3, '${path.module}/outputs/config.yaml') })),

  -- ── Expressions & functions ───────────────────────────────────────────

  -- for expression (list)
  s('for-list', fmt([[
[for {} in {} : {}.{}]
]], { i(1, 'item'), i(2, 'var.items'), i(3, 'item'), i(4, 'id') })),

  -- for expression (map)
  s('for-map', fmt([[
{{for {} in {} : {}.{} => {}.{}}}
]], { i(1, 'item'), i(2, 'var.items'), i(3, 'item'), i(4, 'key'), i(5, 'item'), i(6, 'value') })),

  -- for expression with filter
  s('for-filter', fmt([[
[for {} in {} : {}.{} if {}.{}]
]], { i(1, 'item'), i(2, 'var.items'), i(3, 'item'), i(4, 'id'), i(5, 'item'), i(6, 'enabled') })),

  -- conditional expression
  s('conditional', fmt([[
{} ? {} : {}
]], { i(1, 'var.enable_feature'), i(2, '"enabled"'), i(3, '"disabled"') })),

  -- templatefile function
  s('templatefile', fmt([[
templatefile("${{path.module}}/templates/{}", {{
  {} = {}
}})
]], { i(1, 'config.tpl'), i(2, 'variable_name'), i(3, 'var.value') })),

  -- try expression
  s('try', fmt([[
try({}, {})
]], { i(1, 'var.optional_value.attribute'), i(2, 'null') })),

  -- toset (common for for_each)
  s('toset', fmt([[
toset([{}])
]], { i(1, '"us-east-1", "eu-west-1"') })),

  -- flatten (common for nested structures)
  s('flatten', fmt([[
flatten([for {} in {} : {}.{}])
]], { i(1, 'item'), i(2, 'var.items'), i(3, 'item'), i(4, 'sub_items') })),

})
