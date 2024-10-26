# --- Public Network ACL Configuration --- #

# Define the Public NACL to control inbound and outbound rules for the public subnet
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.vpc.id # Attach NACL to the VPC

  tags = {
    Name        = "${var.name_prefix}-public-nacl" # Dynamic name for the public NACL
    Environment = var.environment                  # Environment tag for easy identification
  }
}

# --- Public NACL Rules --- #

# Rule: Allow HTTP traffic (port 80) inbound from any IP address
resource "aws_network_acl_rule" "public_inbound_allow_http" {
  network_acl_id = aws_network_acl.public_nacl.id # Attach rule to the public NACL
  rule_number    = 100                            # Define rule priority
  egress         = false                          # Inbound rule
  protocol       = "tcp"                          # TCP protocol for HTTP
  from_port      = 80                             # Start of port range for HTTP
  to_port        = 80                             # End of port range for HTTP
  cidr_block     = "0.0.0.0/0"                    # Allow from any IP address
  rule_action    = "allow"                        # Allow HTTP traffic
}

# Rule: Allow HTTPS traffic (port 443) inbound from any IP address
resource "aws_network_acl_rule" "public_inbound_allow_https" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  from_port      = 443 # Port for HTTPS
  to_port        = 443
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# Rule: Deny all other inbound TCP traffic to the public subnet for security
resource "aws_network_acl_rule" "public_inbound_deny" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  from_port      = 0
  to_port        = 65535 # Deny all TCP traffic not explicitly allowed
  cidr_block     = "0.0.0.0/0"
  rule_action    = "deny"
}

# Rule: Allow all outbound TCP traffic from the public subnet to any destination
resource "aws_network_acl_rule" "public_outbound_allow" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 200
  egress         = true # Outbound rule
  protocol       = "tcp"
  from_port      = 0
  to_port        = 65535
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# Associate the public NACL with the public subnet for rule application
resource "aws_network_acl_association" "public_nacl_association" {
  subnet_id      = aws_subnet.public_subnet.id    # Reference public subnet ID
  network_acl_id = aws_network_acl.public_nacl.id # Link to the public NACL
}

# --- Private Network ACL Configuration --- #

# Define the Private NACL to control inbound and outbound rules for the private subnets
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.name_prefix}-private-nacl" # Dynamic name for the private NACL
    Environment = var.environment                   # Environment tag
  }
}

# --- Private NACL Rules --- #

# Rule: Deny all inbound TCP traffic to the private subnets
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

# Rule: Allow all outbound TCP traffic from the private subnets to any destination
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
  subnet_id      = aws_subnet.private_subnet_1.id  # Reference private subnet 1 ID
  network_acl_id = aws_network_acl.private_nacl.id # Link to the private NACL
}

# Associate the private NACL with the second private subnet
resource "aws_network_acl_association" "private_nacl_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id  # Reference private subnet 2 ID
  network_acl_id = aws_network_acl.private_nacl.id # Link to the private NACL
}