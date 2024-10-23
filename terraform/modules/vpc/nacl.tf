# Public NACL configuration
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name        = "dev-public-nacl"
    Environment = "dev"
  }
}

# Public NACL rules: Allow HTTP/HTTPS inbound and all outbound traffic
resource "aws_network_acl_rule" "public_inbound_allow" {
  count          = 2 # We are going to create two rules: one for HTTP and one for HTTPS
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100 + count.index * 10 # 100 for HTTP, 110 for HTTPS
  egress         = false
  protocol       = "tcp"
  from_port      = element([80, 443], count.index)
  to_port        = element([80, 443], count.index)
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# Public NACL rule: Deny all other inbound traffic
resource "aws_network_acl_rule" "public_inbound_deny" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 120
  egress         = false
  protocol       = "-1" # All protocols
  cidr_block     = "0.0.0.0/0"
  rule_action    = "deny"
}

# Public NACL rule: Allow all outbound traffic
resource "aws_network_acl_rule" "public_outbound_allow" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 200
  egress         = true
  protocol       = "-1" # All protocols
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# Associate the public NACL with the public subnet
resource "aws_network_acl_association" "public_nacl_association" {
  subnet_id      = aws_subnet.public_subnet.id
  network_acl_id = aws_network_acl.public_nacl.id
}

# Private NACL configuration
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name        = "dev-private-nacl"
    Environment = "dev"
  }
}

# Private NACL rule: Deny all inbound traffic
resource "aws_network_acl_rule" "private_inbound_deny" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "-1" # All protocols
  cidr_block     = "0.0.0.0/0"
  rule_action    = "deny"
}

# Private NACL rule: Allow all outbound traffic
resource "aws_network_acl_rule" "private_outbound_allow" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 200
  egress         = true
  protocol       = "-1" # All protocols
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

# Associate the private NACL with the first private subnet
resource "aws_network_acl_association" "private_nacl_association_1" {
  subnet_id      = aws_subnet.dev_private_subnet_1.id
  network_acl_id = aws_network_acl.private_nacl.id
}

# Associate the private NACL with the second private subnet
resource "aws_network_acl_association" "private_nacl_association_2" {
  subnet_id      = aws_subnet.dev_private_subnet_2.id
  network_acl_id = aws_network_acl.private_nacl.id
}
