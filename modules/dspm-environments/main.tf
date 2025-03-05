data "aws_region" "current" {}

resource "aws_vpc" "VPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = {
    Name                        = "${var.deployment_name}-VPC"
    (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
  }
}

resource "aws_internet_gateway" "InternetGateway" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name                        = "${var.deployment_name}-Gateway"
    (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
  }

  depends_on = [aws_vpc.VPC]
}

resource "aws_subnet" "DBSubnetA" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = local.availability_zones[0]
  tags = {
    Name                        = "${var.deployment_name}-DB-A"
    (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
  }
}

resource "aws_subnet" "DBSubnetB" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = local.availability_zones[1]
  tags = {
    Name                        = "${var.deployment_name}-DB-B"
    (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
  }
}

resource "aws_db_subnet_group" "DBSubnetGroup" {
  name        = "${var.deployment_name}-db-subnet-group"
  description = "CrowdStrike Security DB subnet group"
  subnet_ids  = [aws_subnet.DBSubnetA.id, aws_subnet.DBSubnetB.id]

  tags = {
    Name                        = "${var.deployment_name}-DBSubnetGroup"
    (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    (local.logical_tag_key)     = local.logical_subnet_group
  }
}

resource "aws_redshift_subnet_group" "RedshiftSubnetGroup" {
  name        = "${var.deployment_name}-redshift-subnet-group"
  description = "CrowdStrike Security Redshift subnet group"
  subnet_ids  = [aws_subnet.DBSubnetA.id, aws_subnet.DBSubnetB.id]

  tags = {
    Name                        = "${var.deployment_name}-RedshiftSubnetGroup"
    (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    (local.logical_tag_key)     = local.logical_redshift_subnet_group
  }
}

resource "aws_subnet" "PublicSubnet" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = local.availability_zones[0]
  tags = {
    Name                        = "${var.deployment_name}-Public"
    (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
  }
}

resource "aws_subnet" "PrivateSubnet" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = local.availability_zones[0]
  tags = {
    Name                        = "${var.deployment_name}-Private"
    (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    (local.logical_tag_key)     = local.logical_private_subnet
  }
}

resource "aws_route_table" "PublicRouteTable" {
  vpc_id = aws_vpc.VPC.id

  // PublicRoute1
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.InternetGateway.id
  }

  tags = {
    Name                        = "${var.deployment_name}-Public"
    (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
  }

  depends_on = [aws_internet_gateway.InternetGateway]
}

resource "aws_eip" "ElasticIPAddress" {
  domain = "vpc"
  tags = {
    Name                        = "EIP-${var.deployment_name}"
    (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    (local.logical_tag_key)     = local.logical_elastic_ip
  }
}

resource "aws_nat_gateway" "NATGateway" {
  allocation_id = aws_eip.ElasticIPAddress.id
  subnet_id     = aws_subnet.PublicSubnet.id

  tags = {
    Name                        = "NAT-${var.deployment_name}"
    (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
  }
}


resource "aws_route_table" "PrivateRouteTable" {
  vpc_id = aws_vpc.VPC.id

  // PrivateRoute1
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATGateway.id
  }

  tags = {
    Name                        = "${var.deployment_name}-Private"
    (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
  }
}

resource "aws_route_table_association" "PublicSubnetRouteTableAssociation" {
  subnet_id      = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_route_table_association" "PrivateSubnetRouteTableAssociation" {
  subnet_id      = aws_subnet.PrivateSubnet.id
  route_table_id = aws_route_table.PrivateRouteTable.id
}

resource "aws_security_group" "EC2SecurityGroup" {
  #checkov:skip=CKV_AWS_382:Data scanner must be allowed to access undetermined ports to support scanning new services
  name        = "EC2SecurityGroup"
  description = "Security group attached to CrowdStrike provisioned EC2 instances for running data scanners"
  vpc_id      = aws_vpc.VPC.id

  // General outbound traffic
  egress {
    description = "Security group attached to EC2"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                        = "${var.deployment_name}-EC2"
    (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    (local.logical_tag_key)     = local.logical_ec2_security_group
  }
}

resource "aws_security_group" "DBSecurityGroup" {
  name        = "DBSecurityGroup"
  description = "Security group attached to RDS instance to allow EC2 instances with specific security groups attached to connect to the database"
  vpc_id      = aws_vpc.VPC.id

  // postgres
  ingress {
    description     = "access for postgres port"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.EC2SecurityGroup.id]
  }

  // mysql
  ingress {
    description     = "access for mysql port"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.EC2SecurityGroup.id]
  }

  // oracle
  ingress {
    description     = "access for oracle db port"
    from_port       = 1521
    to_port         = 1523
    protocol        = "tcp"
    security_groups = [aws_security_group.EC2SecurityGroup.id]
  }

  // sql server
  ingress {
    description     = "access for sql server port"
    from_port       = 1433
    to_port         = 1433
    protocol        = "tcp"
    security_groups = [aws_security_group.EC2SecurityGroup.id]
  }

  // mongo
  ingress {
    description     = "access for mongodb port"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.EC2SecurityGroup.id]
  }

  // redis
  ingress {
    description     = "access for redis port"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.EC2SecurityGroup.id]
  }

  // cassandra
  ingress {
    description     = "access for cassandra port"
    from_port       = 9042
    to_port         = 9042
    protocol        = "tcp"
    security_groups = [aws_security_group.EC2SecurityGroup.id]
  }

  // open search
  ingress {
    description     = "access for open search port"
    from_port       = 9200
    to_port         = 9200
    protocol        = "tcp"
    security_groups = [aws_security_group.EC2SecurityGroup.id]
  }

  // redshift
  ingress {
    description     = "access for redshift port"
    from_port       = 5439
    to_port         = 5439
    protocol        = "tcp"
    security_groups = [aws_security_group.EC2SecurityGroup.id]
  }

  tags = {
    Name                        = "${var.deployment_name}-DB"
    (local.crowdstrike_tag_key) = local.crowdstrike_tag_value
    (local.logical_tag_key)     = local.logical_db_security_group
  }
}

resource "aws_iam_role_policy" "vpc_policy" {
  name = "RunDataScanner-${local.aws_region}-${aws_vpc.VPC.id}"
  role = var.dspm_role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowRunInstances"
        Effect = "Allow"
        Action = [
          "ec2:RunInstances"
        ]
        Resource = [
          "arn:aws:ec2:*:${local.account_id}:security-group/*",
          "arn:aws:ec2:*:${local.account_id}:subnet/*"
        ]
        Condition = {
          StringEquals = {
            "ec2:Vpc" = "arn:aws:ec2:${local.aws_region}:${local.account_id}:vpc/${aws_vpc.VPC.id}"
          }
        }
      }
    ]
  })
}
