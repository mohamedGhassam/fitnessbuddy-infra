locals {
  region      = "eu-north-1"
  k3s_version = "v1.36.6+k3s1"
}


data "aws_ami" "ubuntu_arm" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"]
  }
  filter {
    name   = "architecture"
    values = ["arm64"] # t4g = Graviton = ARM; an x86 image won't boot on it
  }
}



resource "aws_instance" "server" {
  ami                    = data.aws_ami.ubuntu_arm.id
  instance_type          = "t4g.small"
  subnet_id              = aws_default_subnet.a.id
  vpc_security_group_ids = [aws_security_group.server.id]
  iam_instance_profile   = aws_iam_instance_profile.node["server"].name

  user_data = templatefile("${path.module}/userdata/server.sh.tftpl", {
    k3s_version = local.k3s_version
    region      = local.region
  })

  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  credit_specification {
    cpu_credits = "standard"
  }
  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  lifecycle {
    ignore_changes = [ami, user_data]
  }
  tags = { Name = "fitnessbuddy-server" }
}

resource "aws_instance" "agent" {
  ami                    = data.aws_ami.ubuntu_arm.id
  instance_type          = "t4g.micro"
  subnet_id              = aws_default_subnet.a.id
  vpc_security_group_ids = [aws_security_group.agent.id]
  iam_instance_profile   = aws_iam_instance_profile.node["agent"].name

  user_data = templatefile("${path.module}/userdata/agent.sh.tftpl", {
    region      = local.region
    k3s_version = local.k3s_version
    server_ip   = aws_instance.server.private_ip
  })

  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    encrypted             = true
    delete_on_termination = false
  }

  lifecycle {
    ignore_changes = [ami, user_data]
  }

  tags = { Name = "fitnessbuddy-agent" }
}