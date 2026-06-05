local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

ls.add_snippets('terraform', {

  -- ── Core blocks ───────────────────────────────────────────────────────

  s('provider', fmt([[
provider "{}" {{
  {}
}}
]], { i(1, 'aws'), i(2) })),

  s('resource', fmt([[
resource "{}" "{}" {{
  {}
}}
]], { i(1, 'aws_instance'), i(2, 'this'), i(3) })),

  s('data', fmt([[
data "{}" "{}" {{
  {}
}}
]], { i(1, 'aws_ami'), i(2, 'this'), i(3) })),

  s('module', fmt([[
module "{}" {{
  source = "{}"

  {}
}}
]], { i(1, 'name'), i(2, './modules/name'), i(3) })),

  s('variable', fmt([[
variable "{}" {{
  description = "{}"
  type        = {}
  default     = {}
}}
]], { i(1, 'name'), i(2, 'description'), i(3, 'string'), i(4, 'null') })),

  s('output', fmt([[
output "{}" {{
  description = "{}"
  value       = {}
}}
]], { i(1, 'name'), i(2, 'description'), i(3) })),

  s('locals', fmt([[
locals {{
  {} = {}
}}
]], { i(1, 'name'), i(2, 'value') })),

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

  -- ── Backend blocks ────────────────────────────────────────────────────

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

  s('backend-gcs', fmt([[
terraform {{
  backend "gcs" {{
    bucket = "{}"
    prefix = "{}"
  }}
}}
]], { i(1, 'my-tfstate-bucket'), i(2, 'env/terraform') })),

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

  s('backend-consul', fmt([[
terraform {{
  backend "consul" {{
    address = "{}"
    scheme  = "https"
    path    = "{}"
  }}
}}
]], { i(1, 'consul.example.com:8500'), i(2, 'terraform/state') })),

  s('backend-local', fmt([[
terraform {{
  backend "local" {{
    path = "{}"
  }}
}}
]], { i(1, 'terraform.tfstate') })),

  -- ── Cloud (HCP Terraform) ─────────────────────────────────────────────

  s('cloud', fmt([[
terraform {{
  cloud {{
    organization = "{}"

    workspaces {{
      name = "{}"
    }}
  }}
}}
]], { i(1, 'my-org'), i(2, 'my-workspace') })),

  -- ── Meta-argument blocks ──────────────────────────────────────────────

  s('lifecycle', fmt([[
lifecycle {{
  create_before_destroy = {}
  prevent_destroy       = {}
  ignore_changes        = [{}]
}}
]], { i(1, 'true'), i(2, 'false'), i(3) })),

  s('dynamic', fmt([[
dynamic "{}" {{
  for_each = {}
  content {{
    {} = {}.value.{}
  }}
}}
]], { i(1, 'ingress'), i(2, 'var.ingress_rules'), i(3, 'from_port'), i(4, 'ingress'), i(5, 'from_port') })),

  -- ── Provisioner blocks ────────────────────────────────────────────────

  s('provisioner', fmt([[
provisioner "local-exec" {{
  command = "{}"
}}
]], { i(1, 'echo "done"') })),

  s('provisioner-remote', fmt([[
provisioner "remote-exec" {{
  inline = [
    "{}",
  ]
}}
]], { i(1, 'sudo apt-get update') })),

  s('connection', fmt([[
connection {{
  type        = "{}"
  user        = "{}"
  host        = {}
  private_key = file({})
}}
]], { i(1, 'ssh'), i(2, 'ubuntu'), i(3, 'self.public_ip'), i(4, 'var.private_key_path') })),

  -- ── Provider presets ──────────────────────────────────────────────────

  s('provider-aws', fmt([[
provider "aws" {{
  region  = var.aws_region
  profile = "{}"
}}
]], { i(1, 'default') })),

  s('provider-gcp', fmt([[
provider "google" {{
  project = var.project_id
  region  = var.region
  zone    = var.zone
}}
]], {})),

  s('provider-azurerm', fmt([[
provider "azurerm" {{
  features {{}}
  subscription_id = var.subscription_id
}}
]], {})),

  -- ── AWS resources ─────────────────────────────────────────────────────

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

  s('aws-sg', fmt([[
resource "aws_security_group" "{}" {{
  name        = "{}"
  description = "{}"
  vpc_id      = {}

  ingress {{
    from_port   = {}
    to_port     = {}
    protocol    = "tcp"
    cidr_blocks = ["{}"]
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
]], { i(1, 'this'), i(2, 'my-sg'), i(3, 'My security group'), i(4, 'var.vpc_id'), i(5, '443'), i(6, '443'), i(7, '0.0.0.0/0'), i(8, 'my-sg') })),

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

  s('aws-iam-role', fmt([[
resource "aws_iam_role" "{}" {{
  name = "{}"

  assume_role_policy = jsonencode({{
    Version = "2012-10-17"
    Statement = [
      {{
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {{ Service = "{}" }}
      }},
    ]
  }})

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'my-role'), i(3, 'ec2.amazonaws.com') })),

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

  skip_final_snapshot = true
  multi_az            = false

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'my-db'), i(3, 'postgres'), i(4, '15.4'), i(5, 'db.t3.micro'), i(6, '20'), i(7, 'mydb'), i(8, 'this'), i(9, 'this') })),

  -- ── Networking ───────────────────────────────────────────────────────

  s('aws-subnet', fmt([[
resource "aws_subnet" "{}" {{
  vpc_id            = {}
  cidr_block        = "{}"
  availability_zone = "{}"

  map_public_ip_on_launch = {}

  tags = merge(local.common_tags, {{
    Name = "{}"
  }})
}}
]], { i(1, 'public'), i(2, 'aws_vpc.this.id'), i(3, '10.0.1.0/24'), i(4, 'us-east-1a'), i(5, 'true'), i(6, 'my-public-subnet') })),

  s('aws-igw', fmt([[
resource "aws_internet_gateway" "{}" {{
  vpc_id = {}

  tags = merge(local.common_tags, {{
    Name = "{}"
  }})
}}
]], { i(1, 'this'), i(2, 'aws_vpc.this.id'), i(3, 'my-igw') })),

  s('aws-eip', fmt([[
resource "aws_eip" "{}" {{
  domain     = "vpc"
  depends_on = [aws_internet_gateway.{}]

  tags = merge(local.common_tags, {{
    Name = "{}"
  }})
}}
]], { i(1, 'nat'), i(2, 'this'), i(3, 'my-eip') })),

  s('aws-nat', fmt([[
resource "aws_nat_gateway" "{}" {{
  allocation_id = aws_eip.{}.id
  subnet_id     = aws_subnet.{}.id

  tags = merge(local.common_tags, {{
    Name = "{}"
  }})
}}
]], { i(1, 'this'), i(2, 'nat'), i(3, 'public'), i(4, 'my-nat-gw') })),

  s('aws-route-table', fmt([[
resource "aws_route_table" "{}" {{
  vpc_id = {}

  route {{
    cidr_block = "0.0.0.0/0"
    gateway_id = {}
  }}

  tags = merge(local.common_tags, {{
    Name = "{}"
  }})
}}

resource "aws_route_table_association" "{}" {{
  subnet_id      = aws_subnet.{}.id
  route_table_id = aws_route_table.{}.id
}}
]], { i(1, 'public'), i(2, 'aws_vpc.this.id'), i(3, 'aws_internet_gateway.this.id'), i(4, 'public-rt'), i(5, 'public'), i(6, 'public'), i(7, 'public') })),

  s('aws-vpc-endpoint', fmt([[
resource "aws_vpc_endpoint" "{}" {{
  vpc_id            = {}
  service_name      = "com.amazonaws.{}.{}"
  vpc_endpoint_type = "{}"

  tags = merge(local.common_tags, {{
    Name = "{}"
  }})
}}
]], { i(1, 'this'), i(2, 'aws_vpc.this.id'), i(3, 'us-east-1'), i(4, 's3'), i(5, 'Gateway'), i(6, 'my-vpc-endpoint') })),

  -- ── Compute ───────────────────────────────────────────────────────────

  s('aws-key-pair', fmt([[
resource "aws_key_pair" "{}" {{
  key_name   = "{}"
  public_key = file("{}")
}}
]], { i(1, 'this'), i(2, 'my-key'), i(3, '~/.ssh/id_rsa.pub') })),

  s('aws-launch-template', fmt([[
resource "aws_launch_template" "{}" {{
  name_prefix   = "{}"
  image_id      = data.aws_ami.{}.id
  instance_type = "{}"

  vpc_security_group_ids = [{}]

  iam_instance_profile {{
    name = aws_iam_instance_profile.{}.name
  }}

  user_data = base64encode(templatefile("${{path.module}}/templates/userdata.sh.tpl", {{}}))

  tag_specifications {{
    resource_type = "instance"
    tags = merge(local.common_tags, {{
      Name = "{}"
    }})
  }}

  lifecycle {{
    create_before_destroy = true
  }}
}}
]], { i(1, 'this'), i(2, 'my-lt-'), i(3, 'amazon_linux'), i(4, 't3.micro'), i(5, 'aws_security_group.this.id'), i(6, 'this'), i(7, 'my-instance') })),

  s('aws-asg', fmt([[
resource "aws_autoscaling_group" "{}" {{
  name                = "{}"
  vpc_zone_identifier = {}
  min_size            = {}
  max_size            = {}
  desired_capacity    = {}

  launch_template {{
    id      = aws_launch_template.{}.id
    version = "$Latest"
  }}

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {{
    key                 = "Name"
    value               = "{}"
    propagate_at_launch = true
  }}
}}
]], { i(1, 'this'), i(2, 'my-asg'), i(3, 'var.private_subnet_ids'), i(4, '2'), i(5, '10'), i(6, '2'), i(7, 'this'), i(8, 'my-asg-instance') })),

  s('aws-alb', fmt([[
resource "aws_lb" "{}" {{
  name               = "{}"
  internal           = {}
  load_balancer_type = "application"
  security_groups    = [{}]
  subnets            = {}

  enable_deletion_protection = false

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'my-alb'), i(3, 'false'), i(4, 'aws_security_group.alb.id'), i(5, 'var.public_subnet_ids') })),

  s('aws-alb-tg', fmt([[
resource "aws_lb_target_group" "{}" {{
  name     = "{}"
  port     = {}
  protocol = "HTTP"
  vpc_id   = {}

  health_check {{
    path                = "{}"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
  }}

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'my-tg'), i(3, '8080'), i(4, 'aws_vpc.this.id'), i(5, '/health') })),

  s('aws-alb-listener', fmt([[
resource "aws_lb_listener" "{}" {{
  load_balancer_arn = aws_lb.{}.arn
  port              = {}
  protocol          = "{}"

  default_action {{
    type             = "forward"
    target_group_arn = aws_lb_target_group.{}.arn
  }}
}}
]], { i(1, 'http'), i(2, 'this'), i(3, '443'), i(4, 'HTTPS'), i(5, 'this') })),

  -- ── Containers ────────────────────────────────────────────────────────

  s('aws-ecr', fmt([[
resource "aws_ecr_repository" "{}" {{
  name                 = "{}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {{
    scan_on_push = true
  }}

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'my-app') })),

  s('aws-ecs-cluster', fmt([[
resource "aws_ecs_cluster" "{}" {{
  name = "{}"

  setting {{
    name  = "containerInsights"
    value = "enabled"
  }}

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'my-cluster') })),

  s('aws-ecs-task', fmt([[
resource "aws_ecs_task_definition" "{}" {{
  family                   = "{}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "{}"
  memory                   = "{}"
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([{{
    name      = "{}"
    image     = "{}"
    essential = true
    portMappings = [{{
      containerPort = {}
      protocol      = "tcp"
    }}]
    logConfiguration = {{
      logDriver = "awslogs"
      options = {{
        awslogs-group         = aws_cloudwatch_log_group.{}.name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }}
    }}
  }}])

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'my-task'), i(3, '256'), i(4, '512'), i(5, 'my-app'), i(6, 'my-image:latest'), i(7, '8080'), i(8, 'this') })),

  s('aws-ecs-service', fmt([[
resource "aws_ecs_service" "{}" {{
  name            = "{}"
  cluster         = aws_ecs_cluster.{}.id
  task_definition = aws_ecs_task_definition.{}.arn
  desired_count   = {}
  launch_type     = "FARGATE"

  network_configuration {{
    subnets          = {}
    security_groups  = [{}]
    assign_public_ip = false
  }}

  load_balancer {{
    target_group_arn = aws_lb_target_group.{}.arn
    container_name   = "{}"
    container_port   = {}
  }}

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'my-service'), i(3, 'this'), i(4, 'this'), i(5, '2'), i(6, 'var.private_subnet_ids'), i(7, 'aws_security_group.this.id'), i(8, 'this'), i(9, 'my-app'), i(10, '8080') })),

  s('aws-eks-node-group', fmt([[
resource "aws_eks_node_group" "{}" {{
  cluster_name    = aws_eks_cluster.{}.name
  node_group_name = "{}"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = {}

  instance_types = ["{}"]

  scaling_config {{
    desired_size = {}
    min_size     = {}
    max_size     = {}
  }}

  update_config {{
    max_unavailable = 1
  }}

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'this'), i(3, 'my-nodes'), i(4, 'var.private_subnet_ids'), i(5, 't3.medium'), i(6, '2'), i(7, '1'), i(8, '5') })),

  -- ── Storage ───────────────────────────────────────────────────────────

  s('aws-s3-policy', fmt([[
resource "aws_s3_bucket_policy" "{}" {{
  bucket = aws_s3_bucket.{}.id

  policy = jsonencode({{
    Version = "2012-10-17"
    Statement = [
      {{
        Sid       = "{}"
        Effect    = "Allow"
        Principal = {{ AWS = "{}" }}
        Action    = ["s3:GetObject"]
        Resource  = "${{aws_s3_bucket.{}.arn}}/*"
      }},
    ]
  }})
}}
]], { i(1, 'this'), i(2, 'this'), i(3, 'AllowAccess'), i(4, '*'), i(5, 'this') })),

  s('aws-s3-public-block', fmt([[
resource "aws_s3_bucket_public_access_block" "{}" {{
  bucket = aws_s3_bucket.{}.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}}
]], { i(1, 'this'), i(2, 'this') })),

  s('aws-efs', fmt([[
resource "aws_efs_file_system" "{}" {{
  creation_token = "{}"
  encrypted      = true

  tags = merge(local.common_tags, {{
    Name = "{}"
  }})
}}

resource "aws_efs_mount_target" "{}" {{
  file_system_id  = aws_efs_file_system.{}.id
  subnet_id       = {}
  security_groups = [{}]
}}
]], { i(1, 'this'), i(2, 'my-efs'), i(3, 'my-efs'), i(4, 'this'), i(5, 'this'), i(6, 'var.subnet_id'), i(7, 'aws_security_group.efs.id') })),

  s('aws-dynamodb', fmt([[
resource "aws_dynamodb_table" "{}" {{
  name         = "{}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "{}"

  attribute {{
    name = "{}"
    type = "S"
  }}

  point_in_time_recovery {{
    enabled = true
  }}

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'my-table'), i(3, 'id'), i(4, 'id') })),

  -- ── Database ─────────────────────────────────────────────────────────

  s('aws-db-subnet-group', fmt([[
resource "aws_db_subnet_group" "{}" {{
  name       = "{}"
  subnet_ids = {}

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'my-db-subnet-group'), i(3, 'var.private_subnet_ids') })),

  s('aws-elasticache', fmt([[
resource "aws_elasticache_replication_group" "{}" {{
  replication_group_id = "{}"
  description          = "{}"
  node_type            = "{}"
  num_cache_clusters   = {}
  engine_version       = "{}"
  port                 = 6379

  subnet_group_name  = aws_elasticache_subnet_group.{}.name
  security_group_ids = [{}]

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  tags = local.common_tags
}}

resource "aws_elasticache_subnet_group" "{}" {{
  name       = "{}"
  subnet_ids = {}
}}
]], { i(1, 'this'), i(2, 'my-redis'), i(3, 'Redis cluster'), i(4, 'cache.t3.micro'), i(5, '2'), i(6, '7.0'), i(7, 'this'), i(8, 'aws_security_group.redis.id'), i(9, 'this'), i(10, 'my-redis-subnet'), i(11, 'var.private_subnet_ids') })),

  -- ── IAM ───────────────────────────────────────────────────────────────

  s('aws-iam-policy', fmt([[
resource "aws_iam_policy" "{}" {{
  name        = "{}"
  description = "{}"

  policy = jsonencode({{
    Version = "2012-10-17"
    Statement = [
      {{
        Effect   = "Allow"
        Action   = [{}]
        Resource = "{}"
      }},
    ]
  }})

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'my-policy'), i(3, 'My IAM policy'), i(4, '"s3:GetObject", "s3:PutObject"'), i(5, '*') })),

  s('aws-iam-policy-attachment', fmt([[
resource "aws_iam_role_policy_attachment" "{}" {{
  role       = aws_iam_role.{}.name
  policy_arn = {}
}}
]], { i(1, 'this'), i(2, 'this'), i(3, 'aws_iam_policy.this.arn') })),

  s('aws-iam-instance-profile', fmt([[
resource "aws_iam_instance_profile" "{}" {{
  name = "{}"
  role = aws_iam_role.{}.name

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'my-profile'), i(3, 'this') })),

  s('aws-iam-oidc', fmt([[
data "tls_certificate" "eks" {{
  url = aws_eks_cluster.{}.identity[0].oidc[0].issuer
}}

resource "aws_iam_openid_connect_provider" "{}" {{
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.{}.identity[0].oidc[0].issuer

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'eks'), i(3, 'this') })),

  -- ── Lambda ────────────────────────────────────────────────────────────

  s('aws-lambda', fmt([[
resource "aws_lambda_function" "{}" {{
  function_name = "{}"
  role          = aws_iam_role.lambda.arn
  handler       = "{}"
  runtime       = "{}"
  timeout       = {}
  memory_size   = {}

  filename         = data.archive_file.{}.output_path
  source_code_hash = data.archive_file.{}.output_base64sha256

  environment {{
    variables = {{
      {} = {}
    }}
  }}

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'my-function'), i(3, 'index.handler'), i(4, 'nodejs20.x'), i(5, '30'), i(6, '128'), i(7, 'this'), i(8, 'this'), i(9, 'ENV'), i(10, 'var.env') })),

  s('aws-lambda-permission', fmt([[
resource "aws_lambda_permission" "{}" {{
  statement_id  = "{}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.{}.function_name
  principal     = "{}"
  source_arn    = {}
}}
]], { i(1, 'this'), i(2, 'AllowExecution'), i(3, 'this'), i(4, 'apigateway.amazonaws.com'), i(5, 'aws_api_gateway_rest_api.this.execution_arn') })),

  -- ── Monitoring & Alerting ─────────────────────────────────────────────

  s('aws-log-group', fmt([[
resource "aws_cloudwatch_log_group" "{}" {{
  name              = "/{}/{}"
  retention_in_days = {}

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'app'), i(3, 'my-service'), i(4, '30') })),

  s('aws-cloudwatch-alarm', fmt([[
resource "aws_cloudwatch_metric_alarm" "{}" {{
  alarm_name          = "{}"
  comparison_operator = "{}"
  evaluation_periods  = {}
  metric_name         = "{}"
  namespace           = "{}"
  period              = {}
  statistic           = "Average"
  threshold           = {}

  alarm_description = "{}"
  alarm_actions     = [aws_sns_topic.{}.arn]

  dimensions = {{
    {} = {}
  }}

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'high-cpu'), i(3, 'GreaterThanThreshold'), i(4, '2'), i(5, 'CPUUtilization'), i(6, 'AWS/EC2'), i(7, '120'), i(8, '80'), i(9, 'CPU utilization is too high'), i(10, 'alerts'), i(11, 'InstanceId'), i(12, 'aws_instance.this.id') })),

  s('aws-sns', fmt([[
resource "aws_sns_topic" "{}" {{
  name = "{}"

  tags = local.common_tags
}}

resource "aws_sns_topic_subscription" "{}" {{
  topic_arn = aws_sns_topic.{}.arn
  protocol  = "{}"
  endpoint  = "{}"
}}
]], { i(1, 'alerts'), i(2, 'my-alerts'), i(3, 'this'), i(4, 'alerts'), i(5, 'email'), i(6, 'ops@example.com') })),

  s('aws-sqs', fmt([[
resource "aws_sqs_queue" "{}" {{
  name                       = "{}"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 86400
  visibility_timeout_seconds = 30

  redrive_policy = jsonencode({{
    deadLetterTargetArn = aws_sqs_queue.{}_dlq.arn
    maxReceiveCount     = 4
  }})

  tags = local.common_tags
}}

resource "aws_sqs_queue" "{}_dlq" {{
  name = "{}-dlq"

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'my-queue'), i(3, 'this'), i(4, 'this'), i(5, 'my-queue') })),

  -- ── DNS & TLS ─────────────────────────────────────────────────────────

  s('aws-route53-zone', fmt([[
resource "aws_route53_zone" "{}" {{
  name = "{}"

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'example.com') })),

  s('aws-route53-record', fmt([[
resource "aws_route53_record" "{}" {{
  zone_id = aws_route53_zone.{}.zone_id
  name    = "{}"
  type    = "{}"
  ttl     = {}
  records = [{}]
}}
]], { i(1, 'this'), i(2, 'this'), i(3, 'app.example.com'), i(4, 'A'), i(5, '300'), i(6, 'aws_lb.this.dns_name') })),

  s('aws-acm-cert', fmt([[
resource "aws_acm_certificate" "{}" {{
  domain_name               = "{}"
  subject_alternative_names = ["*.{}"]
  validation_method         = "DNS"

  tags = local.common_tags

  lifecycle {{
    create_before_destroy = true
  }}
}}

resource "aws_acm_certificate_validation" "{}" {{
  certificate_arn         = aws_acm_certificate.{}.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}}
]], { i(1, 'this'), i(2, 'example.com'), i(3, 'example.com'), i(4, 'this'), i(5, 'this') })),

  -- ── Secrets & Config ─────────────────────────────────────────────────

  s('aws-secret', fmt([[
resource "aws_secretsmanager_secret" "{}" {{
  name        = "{}"
  description = "{}"

  tags = local.common_tags
}}

resource "aws_secretsmanager_secret_version" "{}" {{
  secret_id = aws_secretsmanager_secret.{}.id
  secret_string = jsonencode({{
    {} = "{}"
  }})
}}
]], { i(1, 'this'), i(2, 'my-app/secret'), i(3, 'Application secret'), i(4, 'this'), i(5, 'this'), i(6, 'password'), i(7, 'changeme') })),

  s('aws-ssm-param', fmt([[
resource "aws_ssm_parameter" "{}" {{
  name  = "/{}/{}"
  type  = "{}"
  value = {}

  tags = local.common_tags
}}
]], { i(1, 'this'), i(2, 'my-app'), i(3, 'db_password'), i(4, 'SecureString'), i(5, 'var.db_password') })),

  s('aws-kms', fmt([[
resource "aws_kms_key" "{}" {{
  description             = "{}"
  deletion_window_in_days = {}
  enable_key_rotation     = true

  tags = local.common_tags
}}

resource "aws_kms_alias" "{}" {{
  name          = "alias/{}"
  target_key_id = aws_kms_key.{}.key_id
}}
]], { i(1, 'this'), i(2, 'My KMS key'), i(3, '7'), i(4, 'this'), i(5, 'my-key'), i(6, 'this') })),

  -- ── Data sources ─────────────────────────────────────────────────────

  s('data-ami', fmt([[
data "aws_ami" "{}" {{
  most_recent = true
  owners      = ["{}"]

  filter {{
    name   = "name"
    values = ["{}"]
  }}

  filter {{
    name   = "virtualization-type"
    values = ["hvm"]
  }}
}}
]], { i(1, 'amazon_linux'), i(2, 'amazon'), i(3, 'al2023-ami-*-x86_64') })),

  s('data-caller', fmt([[
data "aws_caller_identity" "current" {{}}
data "aws_region" "current" {{}}
data "aws_partition" "current" {{}}
]], {})),

  s('data-vpc', fmt([[
data "aws_vpc" "{}" {{
  tags = {{
    Name = "{}"
  }}
}}
]], { i(1, 'this'), i(2, 'my-vpc') })),

  s('data-subnets', fmt([[
data "aws_subnets" "{}" {{
  filter {{
    name   = "vpc-id"
    values = [{}]
  }}

  tags = {{
    Tier = "{}"
  }}
}}
]], { i(1, 'private'), i(2, 'aws_vpc.this.id'), i(3, 'private') })),

  -- ── Helpers ───────────────────────────────────────────────────────────

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

})
