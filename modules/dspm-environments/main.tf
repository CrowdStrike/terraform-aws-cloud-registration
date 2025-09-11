data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = merge(
    var.tags,
    {
      Name                        = "${var.deployment_name}-VPC"
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    }
  )
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Name                        = "${var.deployment_name}-Gateway"
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    }
  )

  depends_on = [aws_vpc.vpc]
}

resource "aws_subnet" "db_subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, 0)
  availability_zone = data.aws_availability_zones.available.names[0]

  lifecycle {
    ignore_changes = [availability_zone]
  }

  tags = merge(
    var.tags,
    {
      Name                        = "${var.deployment_name}-DB-A"
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    }
  )
}

resource "aws_subnet" "db_subnet_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, 1)
  availability_zone = data.aws_availability_zones.available.names[1]

  lifecycle {
    ignore_changes = [availability_zone]
  }

  tags = merge(
    var.tags,
    {
      Name                        = "${var.deployment_name}-DB-B"
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    }
  )
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "${var.deployment_name}-db-subnet-group"
  description = "CrowdStrike Security DB subnet group"
  subnet_ids  = [aws_subnet.db_subnet_a.id, aws_subnet.db_subnet_b.id]

  tags = merge(
    var.tags,
    {
      Name                        = "${var.deployment_name}-DBSubnetGroup"
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
      (local.logical_tag_key)     = local.logical_subnet_group
    }
  )
}

resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name        = "${var.deployment_name}-redshift-subnet-group"
  description = "CrowdStrike Security Redshift subnet group"
  subnet_ids  = [aws_subnet.db_subnet_a.id, aws_subnet.db_subnet_b.id]

  tags = merge(
    var.tags,
    {
      Name                        = "${var.deployment_name}-RedshiftSubnetGroup"
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
      (local.logical_tag_key)     = local.logical_redshift_subnet_group
    }
  )
}

resource "aws_subnet" "public_subnet" {
  count             = var.dspm_create_nat_gateway ? 1 : 0
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, 2)
  availability_zone = data.aws_availability_zones.available.names[0]

  lifecycle {
    ignore_changes = [availability_zone]
  }

  tags = merge(
    var.tags,
    {
      Name                        = "${var.deployment_name}-Public"
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    }
  )
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, 3)
  availability_zone = data.aws_availability_zones.available.names[0]

  lifecycle {
    ignore_changes = [availability_zone]
  }

  tags = merge(
    var.tags,
    {
      Name                        = "${var.deployment_name}-Private"
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
      (local.logical_tag_key)     = local.logical_private_subnet
    }
  )
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  # PublicRoute1
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = merge(
    var.tags,
    {
      Name                        = "${var.deployment_name}-Public"
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    }
  )

  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_eip" "elastic_ip_address" {
  count  = var.dspm_create_nat_gateway ? 1 : 0
  domain = "vpc"
  tags = merge(
    var.tags,
    {
      Name                        = "EIP-${var.deployment_name}"
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
      (local.logical_tag_key)     = local.logical_elastic_ip
    }
  )
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.dspm_create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.elastic_ip_address[0].id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = merge(
    var.tags,
    {
      Name                        = "NAT-${var.deployment_name}"
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    }
  )
}


resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  # PrivateRoute - conditionally use NAT Gateway or Internet Gateway
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.dspm_create_nat_gateway ? aws_nat_gateway.nat_gateway[0].id : null
    gateway_id     = var.dspm_create_nat_gateway ? null : aws_internet_gateway.internet_gateway.id
  }

  tags = merge(
    var.tags,
    {
      Name                        = "${var.deployment_name}-Private"
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    }
  )
}

resource "aws_route_table_association" "public_subnet_route_table_association" {
  count          = var.dspm_create_nat_gateway ? 1 : 0
  subnet_id      = aws_subnet.public_subnet[0].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_network_acl" "network_acl" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Name                        = "${var.deployment_name}-NACL"
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    }
  )
}

resource "aws_network_acl_rule" "inbound_a" {
  network_acl_id = aws_network_acl.network_acl.id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/1"
}

resource "aws_network_acl_rule" "inbound_b" {
  network_acl_id = aws_network_acl.network_acl.id
  rule_number    = 110
  protocol       = "-1"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "128.0.0.0/1"
}

resource "aws_network_acl_rule" "outbound" {
  network_acl_id = aws_network_acl.network_acl.id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  egress         = true
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_association" "public_subnet_nacl_association" {
  count          = var.dspm_create_nat_gateway ? 1 : 0
  subnet_id      = aws_subnet.public_subnet[0].id
  network_acl_id = aws_network_acl.network_acl.id
}

resource "aws_network_acl_association" "private_subnet_nacl_association" {
  subnet_id      = aws_subnet.private_subnet.id
  network_acl_id = aws_network_acl.network_acl.id
}

resource "aws_network_acl_association" "db_subnet_a_nacl_association" {
  subnet_id      = aws_subnet.db_subnet_a.id
  network_acl_id = aws_network_acl.network_acl.id
}

resource "aws_network_acl_association" "db_subnet_b_nacl_association" {
  subnet_id      = aws_subnet.db_subnet_b.id
  network_acl_id = aws_network_acl.network_acl.id
}

resource "aws_security_group" "ec2_security_group" {
  #checkov:skip=CKV_AWS_382:Data scanner must be allowed to access undetermined ports to support scanning new services
  name        = "EC2SecurityGroup"
  description = "Security group attached to CrowdStrike provisioned EC2 instances for running data scanners"
  vpc_id      = aws_vpc.vpc.id

  # General outbound traffic
  egress {
    description = "Security group attached to EC2"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name                        = "${var.deployment_name}-EC2"
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
      (local.logical_tag_key)     = local.logical_ec2_security_group
    }
  )
}

resource "aws_security_group" "db_security_group" {
  name        = "DBSecurityGroup"
  description = "Security group attached to RDS instance to allow EC2 instances with specific security groups attached to connect to the database"
  vpc_id      = aws_vpc.vpc.id

  # postgres
  ingress {
    description     = "access for postgres port"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_security_group.id]
  }

  # mysql
  ingress {
    description     = "access for mysql port"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_security_group.id]
  }

  # oracle
  ingress {
    description     = "access for oracle db port"
    from_port       = 1521
    to_port         = 1523
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_security_group.id]
  }

  # sql server
  ingress {
    description     = "access for sql server port"
    from_port       = 1433
    to_port         = 1433
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_security_group.id]
  }

  # mongo
  ingress {
    description     = "access for mongodb port"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_security_group.id]
  }

  # redis
  ingress {
    description     = "access for redis port"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_security_group.id]
  }

  # cassandra
  ingress {
    description     = "access for cassandra port"
    from_port       = 9042
    to_port         = 9042
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_security_group.id]
  }

  # open search
  ingress {
    description     = "access for open search port"
    from_port       = 9200
    to_port         = 9200
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_security_group.id]
  }

  # redshift
  ingress {
    description     = "access for redshift port"
    from_port       = 5439
    to_port         = 5439
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_security_group.id]
  }

  tags = merge(
    var.tags,
    {
      Name                        = "${var.deployment_name}-DB"
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
      (local.logical_tag_key)     = local.logical_db_security_group
    }
  )
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${local.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_route_table.id]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:Get*",
          "s3:List*"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:SourceVpc" = aws_vpc.vpc.id
          }
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name                        = "${var.deployment_name}-S3-Endpoint"
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
      (local.logical_tag_key)     = "S3Endpoint"
    }
  )
}

resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${local.aws_region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_route_table.id]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "dynamodb:BatchGet*",
          "dynamodb:Describe*",
          "dynamodb:List*",
          "dynamodb:Get*",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:PartiQLSelect"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:SourceVpc" = aws_vpc.vpc.id
          }
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name                        = "${var.deployment_name}-DynamoDB-Endpoint"
      (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
      (local.logical_tag_key)     = "DynamoDBEndpoint"
    }
  )
}
