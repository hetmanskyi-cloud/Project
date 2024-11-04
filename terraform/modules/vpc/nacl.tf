# --- Public Network ACL Configuration --- #

# Public NACL for controlling inbound and outbound traffic for public subnets
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.vpc.id # Associate with the specified VPC

  tags = {
    Name        = "${var.name_prefix}-public-nacl"
    Environment = var.environment
  }
}

# --- Public NACL Rules --- #

# Ingress Rules: Allow inbound traffic for HTTP, HTTPS, SSH, and ephemeral ports

# Rule: Allow inbound HTTP traffic on port 80
resource "aws_network_acl_rule" "public_inbound_allow_http" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  from_port      = 80
  to_port        = 80
  cidr_block     = "0.0.0.0/0" # Allow from any IP
  rule_action    = "allow"
}

# Rule: Allow inbound HTTPS traffic on port 443
resource "aws_network_acl_rule" "public_inbound_allow_https" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  from_port      = 443
  to_port        = 443
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# Rule: Allow inbound SSH traffic on port 22
# This rule allows inbound SSH access on port 22 from specified IP addresses
resource "aws_network_acl_rule" "public_inbound_allow_ssh" {
  network_acl_id = aws_network_acl.public_nacl.id # Link to Public NACL
  rule_number    = 200                            # Priority for the rule
  egress         = false                          # Inbound rule
  protocol       = "tcp"                          # TCP protocol
  from_port      = 22                             # Start port for SSH
  to_port        = 22                             # End port for SSH
  cidr_block     = var.allowed_ssh_cidr[0]        # Allowed CIDR for SSH access
  rule_action    = "allow"                        # Allow traffic
}

# Rule: Allow inbound ephemeral ports (1024-65535) for return traffic
resource "aws_network_acl_rule" "public_inbound_allow_ephemeral" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 210
  egress         = false
  protocol       = "tcp"
  from_port      = 1024
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# Egress Rules: Allow outbound traffic for HTTP, HTTPS, SSH

# Rule: Allow outbound HTTP traffic on port 80
resource "aws_network_acl_rule" "public_outbound_allow_http" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  from_port      = 80
  to_port        = 80
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# Rule: Allow outbound HTTPS traffic on port 443
resource "aws_network_acl_rule" "public_outbound_allow_https" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 110
  egress         = true
  protocol       = "tcp"
  from_port      = 443
  to_port        = 443
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# Rule: Allow outbound SSH traffic on port 22
resource "aws_network_acl_rule" "public_outbound_allow_ssh" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 200
  egress         = true
  protocol       = "tcp"
  from_port      = 22
  to_port        = 22
  cidr_block     = var.allowed_ssh_cidr[0]
  rule_action    = "allow"
}

# Rule: Deny all other outbound traffic to restrict unnecessary outbound connections
resource "aws_network_acl_rule" "public_outbound_deny_all" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 300
  egress         = true
  protocol       = "-1"        # All protocols
  cidr_block     = "0.0.0.0/0" # Deny to any destination
  rule_action    = "deny"
}

# --- Private Network ACL Configuration --- #

# Private NACL for controlling traffic within private subnets
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.vpc.id # Associate with the specified VPC

  tags = {
    Name        = "${var.name_prefix}-private-nacl"
    Environment = var.environment
  }
}

# --- Private NACL Rules --- #

# Ingress Rules: Allow MySQL and Redis traffic within VPC

# Rule: Allow inbound MySQL traffic on port 3306 within the VPC
resource "aws_network_acl_rule" "private_inbound_allow_mysql" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  from_port      = 3306
  to_port        = 3306
  cidr_block     = aws_vpc.vpc.cidr_block
  rule_action    = "allow"
}

# Rule: Allow inbound Redis traffic on port 6379 within the VPC
resource "aws_network_acl_rule" "private_inbound_allow_redis" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 210
  egress         = false
  protocol       = "tcp"
  from_port      = 6379
  to_port        = 6379
  cidr_block     = aws_vpc.vpc.cidr_block
  rule_action    = "allow"
}

# Outbound Rules: Allow MySQL and Redis traffic within VPC

# Rule: Allow outbound MySQL traffic on port 3306 within the VPC
resource "aws_network_acl_rule" "private_outbound_allow_mysql" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 200
  egress         = true
  protocol       = "tcp"
  from_port      = 3306
  to_port        = 3306
  cidr_block     = aws_vpc.vpc.cidr_block
  rule_action    = "allow"
}

# Rule: Allow outbound Redis traffic on port 6379 within the VPC
resource "aws_network_acl_rule" "private_outbound_allow_redis" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 210
  egress         = true
  protocol       = "tcp"
  from_port      = 6379
  to_port        = 6379
  cidr_block     = aws_vpc.vpc.cidr_block
  rule_action    = "allow"
}

# Rule: Deny all other outbound traffic to ensure only necessary traffic is allowed
resource "aws_network_acl_rule" "private_outbound_deny_all" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 220
  egress         = true
  protocol       = "-1"
  cidr_block     = "0.0.0.0/0"
  rule_action    = "deny"
}

# --- NACL Associations --- #

# Associate the Public NACL with the public subnets
resource "aws_network_acl_association" "public_nacl_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  network_acl_id = aws_network_acl.public_nacl.id
}

resource "aws_network_acl_association" "public_nacl_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  network_acl_id = aws_network_acl.public_nacl.id
}

# Associate the Private NACL with the private subnets
resource "aws_network_acl_association" "private_nacl_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  network_acl_id = aws_network_acl.private_nacl.id
}

resource "aws_network_acl_association" "private_nacl_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  network_acl_id = aws_network_acl.private_nacl.id
}
