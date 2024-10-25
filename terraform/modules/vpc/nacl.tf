# Public NACL configuration
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.name_prefix}-public-nacl" # Dynamic name for public NACL
    Environment = var.environment                  # Dynamic environment tag
  }
}

# Public NACL rules: Allow HTTP/HTTPS inbound and all outbound traffic
resource "aws_network_acl_rule" "public_inbound_allow_http" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  from_port      = 80 # HTTP
  to_port        = 80
  cidr_block     = "0.0.0.0/0" # Allow traffic from any IP
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "public_inbound_allow_https" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  from_port      = 443 # HTTPS
  to_port        = 443
  cidr_block     = "0.0.0.0/0" # Allow traffic from any IP
  rule_action    = "allow"
}

# Public NACL rule: Deny all other inbound traffic (CKV_AWS_352 requires denying all other ports)
resource "aws_network_acl_rule" "public_inbound_deny" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp" # Apply only to TCP protocols
  from_port      = 0
  to_port        = 65535 # Deny all other TCP traffic
  cidr_block     = "0.0.0.0/0"
  rule_action    = "deny"
}

# Public NACL rule: Allow all outbound traffic
resource "aws_network_acl_rule" "public_outbound_allow" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 200
  egress         = true
  protocol       = "tcp" # Allow TCP outbound traffic
  from_port      = 0
  to_port        = 65535
  cidr_block     = "0.0.0.0/0" # Allow outbound traffic to any destination
  rule_action    = "allow"
}

# Associate the public NACL with the public subnet
resource "aws_network_acl_association" "public_nacl_association" {
  subnet_id      = aws_subnet.public_subnet.id
  network_acl_id = aws_network_acl.public_nacl.id
}

# Private NACL configuration
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.name_prefix}-private-nacl" # Dynamic name for private NACL
    Environment = var.environment                   # Dynamic environment tag
  }
}

# Private NACL rule: Deny all inbound traffic
resource "aws_network_acl_rule" "private_inbound_deny" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  from_port      = 0
  to_port        = 65535
  cidr_block     = "0.0.0.0/0" # Deny all inbound traffic
  rule_action    = "deny"
}

# Private NACL rule: Allow all outbound traffic
resource "aws_network_acl_rule" "private_outbound_allow" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 200
  egress         = true
  protocol       = "tcp"
  from_port      = 0
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# Associate the private NACL with the first private subnet
resource "aws_network_acl_association" "private_nacl_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  network_acl_id = aws_network_acl.private_nacl.id
}

# Associate the private NACL with the second private subnet
resource "aws_network_acl_association" "private_nacl_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  network_acl_id = aws_network_acl.private_nacl.id
}
