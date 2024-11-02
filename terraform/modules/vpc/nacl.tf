# --- Public Network ACL Configuration --- #

# Define the Public NACL to control inbound and outbound traffic for public subnets
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.vpc.id # Attach NACL to the VPC

  tags = {
    Name        = "${var.name_prefix}-public-nacl" # Dynamic name for the Public NACL
    Environment = var.environment                  # Environment tag for identification
  }
}

# --- Public NACL Rules --- #

# Rule: Allow inbound SSH traffic (port 22) from any IP address
resource "aws_network_acl_rule" "public_inbound_allow_ssh" {
  network_acl_id = aws_network_acl.public_nacl.id # Associate rule with the Public NACL
  rule_number    = 50                             # Rule priority
  egress         = false                          # Inbound rule
  protocol       = "tcp"                          # TCP protocol
  from_port      = 22                             # SSH port
  to_port        = 22
  cidr_block     = "0.0.0.0/0" # Allow from any IP (use specific IPs in production)
  rule_action    = "allow"     # Allow traffic
}

# Rule: Allow inbound HTTP traffic (port 80) from any IP address
resource "aws_network_acl_rule" "public_inbound_allow_http" {
  network_acl_id = aws_network_acl.public_nacl.id # Associate rule with the Public NACL
  rule_number    = 100                            # Rule priority
  egress         = false                          # Inbound rule
  protocol       = "tcp"                          # TCP protocol
  from_port      = 80                             # HTTP port
  to_port        = 80
  cidr_block     = "0.0.0.0/0" # Allow from any IP
  rule_action    = "allow"     # Allow traffic
}

# Rule: Allow inbound HTTPS traffic (port 443) from any IP address
resource "aws_network_acl_rule" "public_inbound_allow_https" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  from_port      = 443 # HTTPS port
  to_port        = 443
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# Rule: Allow inbound ephemeral ports (1024-65535) for return traffic
resource "aws_network_acl_rule" "public_inbound_allow_ephemeral" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  from_port      = 1024  # Ephemeral port range start
  to_port        = 65535 # Ephemeral port range end
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# Rule: Deny all other inbound traffic
resource "aws_network_acl_rule" "public_inbound_deny_all" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 130
  egress         = false
  protocol       = "-1" # All protocols
  rule_action    = "deny"
  cidr_block     = "0.0.0.0/0"
}

# Rule: Allow all outbound traffic
resource "aws_network_acl_rule" "public_outbound_allow_all" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  egress         = true # Outbound rule
  protocol       = "-1" # All protocols
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# Associate the Public NACL with the public subnets
resource "aws_network_acl_association" "public_nacl_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id  # Public subnet 1 ID
  network_acl_id = aws_network_acl.public_nacl.id # Public NACL ID
}

resource "aws_network_acl_association" "public_nacl_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id  # Public subnet 2 ID
  network_acl_id = aws_network_acl.public_nacl.id # Public NACL ID
}

# --- Private Network ACL Configuration --- #

# Define the Private NACL to control traffic for the private subnets
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.vpc.id # Attach to VPC

  tags = {
    Name        = "${var.name_prefix}-private-nacl"
    Environment = var.environment
  }
}

# --- Private NACL Rules --- #

# Rule: Allow all inbound traffic within the VPC for inter-subnet communication
resource "aws_network_acl_rule" "private_inbound_allow_vpc" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"                   # All protocols
  cidr_block     = aws_vpc.vpc.cidr_block # VPC CIDR block
  rule_action    = "allow"
}

# Rule: Deny all other inbound traffic
resource "aws_network_acl_rule" "private_inbound_deny_all" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 110
  egress         = false
  protocol       = "-1"
  rule_action    = "deny"
  cidr_block     = "0.0.0.0/0"
}

# Rule: Allow all outbound traffic within the VPC
resource "aws_network_acl_rule" "private_outbound_allow_vpc" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  cidr_block     = aws_vpc.vpc.cidr_block
  rule_action    = "allow"
}

# Rule: Deny all other outbound traffic
resource "aws_network_acl_rule" "private_outbound_deny_all" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 110
  egress         = true
  protocol       = "-1"
  rule_action    = "deny"
  cidr_block     = "0.0.0.0/0"
}

# Associate the Private NACL with the private subnets
resource "aws_network_acl_association" "private_nacl_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id # Private subnet 1 ID
  network_acl_id = aws_network_acl.private_nacl.id
}

resource "aws_network_acl_association" "private_nacl_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id # Private subnet 2 ID
  network_acl_id = aws_network_acl.private_nacl.id
}