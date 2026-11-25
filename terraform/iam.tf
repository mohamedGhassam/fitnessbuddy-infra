data "aws_iam_policy_document" "ec2_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {

      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "server_ssm" {
  statement {
    actions   = ["ssm:PutParameter"]
    resources = ["${local.params}/k3s-token"]
  }
  statement {
    effect    = "Deny"
    actions   = ["ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath"]
    resources = [local.params, "${local.params}/*"]
  }
}
data "aws_caller_identity" "me" {

}

data "aws_kms_alias" "ssm" {
  name = "alias/aws/ssm"
}

# agent: may READ every prod parameter (k3s token at boot, app secrets for ESO) and decrypt them via SSM
data "aws_iam_policy_document" "agent_ssm" {
  statement {
    actions   = ["ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath"]
    resources = [local.params, "${local.params}/*"] # folder itself (ByPath) + everything inside
  }
  statement {
    actions   = ["kms:Decrypt"]
    resources = [data.aws_kms_alias.ssm.target_key_arn]
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["ssm.eu-north-1.amazonaws.com"]
    }
  }
}

locals {
  params = "arn:aws:ssm:eu-north-1:${data.aws_caller_identity.me.account_id}:parameter/fitnessbuddy/prod"
}

resource "aws_iam_role" "node" {
  for_each           = toset(["server", "agent"])
  name               = "fitnessbuddy-${each.value}"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
}

resource "aws_iam_instance_profile" "node" {
  for_each = aws_iam_role.node
  name     = each.value.name
  role     = each.value.name
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  for_each   = aws_iam_role.node
  role       = each.value.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "server_ssm" {
  role   = aws_iam_role.node["server"].id
  policy = data.aws_iam_policy_document.server_ssm.json
}

resource "aws_iam_role_policy" "agent_ssm" {
  role   = aws_iam_role.node["agent"].id
  policy = data.aws_iam_policy_document.agent_ssm.json
}