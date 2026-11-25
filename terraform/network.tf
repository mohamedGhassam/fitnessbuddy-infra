resource "aws_default_vpc" "default" {
  tags = { Name = "fitnessbuddy-default-vpc" }
}

resource "aws_default_subnet" "a" {
  availability_zone = "eu-north-1a"
  tags              = { Name = "fitnessbuddy-default-1a" }
}

resource "aws_security_group" "server" {
  name   = "k3s-server"
  vpc_id = aws_default_vpc.default.id

}

resource "aws_vpc_security_group_ingress_rule" "connection_from_agent_to_server_rules" {
  security_group_id            = aws_security_group.server.id
  referenced_security_group_id = aws_security_group.agent.id
  for_each = {
    "api"     = { port = 6443, protocol = "tcp" }
    "vxlan"   = { port = 8472, protocol = "udp" }
    "kubelet" = { port = 10250, protocol = "tcp" }
  }
  ip_protocol = each.value.protocol
  from_port   = each.value.port
  to_port     = each.value.port
  description = "k3s ${each.key} from agent"
}

resource "aws_security_group" "agent" {
  name   = "k3s-agent"
  vpc_id = aws_default_vpc.default.id

}

resource "aws_vpc_security_group_ingress_rule" "connection_from_server_to_agent_rules" {
  security_group_id            = aws_security_group.agent.id
  referenced_security_group_id = aws_security_group.server.id
  for_each = {
    # "api"     = { port = 6443, protocol = "tcp" }
    "vxlan"   = { port = 8472, protocol = "udp" }
    "kubelet" = { port = 10250, protocol = "tcp" }
  }
  ip_protocol = each.value.protocol
  from_port   = each.value.port
  to_port     = each.value.port
  description = "k3s ${each.key} from server"
}


resource "aws_vpc_security_group_egress_rule" "all_out" {
  for_each = {
    "server" = aws_security_group.server.id,
    "agent"  = aws_security_group.agent.id
  }
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = each.value
  description       = "all outbound: SSM , ECR ,CloudFlare"

}