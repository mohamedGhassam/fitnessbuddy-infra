locals {
  # SSM name => version. Bump one number to resend (rotate) that secret.
  secret_versions = {
    "jwt-secret"          = 1
    "usda-api-key"        = 1
    "youtube-api-key"     = 1
    "r2-access"           = 1
    "r2-secret"           = 1
    "pg-backup-r2-access" = 1
    "pg-backup-r2-secret" = 1
    "grafana-cloud-token" = 1
  }
}

# Explicit blocks, not for_each: ephemeral values can't drive for_each.

resource "aws_ssm_parameter" "jwt_secret" {
  name             = "/fitnessbuddy/prod/jwt-secret"
  type             = "SecureString"
  value_wo         = var.jwt_secret
  value_wo_version = local.secret_versions["jwt-secret"]
}

resource "aws_ssm_parameter" "usda_api_key" {
  name             = "/fitnessbuddy/prod/usda-api-key"
  type             = "SecureString"
  value_wo         = var.usda_api_key
  value_wo_version = local.secret_versions["usda-api-key"]
}

resource "aws_ssm_parameter" "youtube_api_key" {
  name             = "/fitnessbuddy/prod/youtube-api-key"
  type             = "SecureString"
  value_wo         = var.youtube_api_key
  value_wo_version = local.secret_versions["youtube-api-key"]
}

resource "aws_ssm_parameter" "r2_access" {
  name             = "/fitnessbuddy/prod/r2-access"
  type             = "SecureString"
  value_wo         = var.r2_access
  value_wo_version = local.secret_versions["r2-access"]
}

resource "aws_ssm_parameter" "r2_secret" {
  name             = "/fitnessbuddy/prod/r2-secret"
  type             = "SecureString"
  value_wo         = var.r2_secret
  value_wo_version = local.secret_versions["r2-secret"]
}

resource "aws_ssm_parameter" "pg_backup_r2_access" {
  name             = "/fitnessbuddy/prod/pg-backup-r2-access"
  type             = "SecureString"
  value_wo         = var.pg_backup_r2_access
  value_wo_version = local.secret_versions["pg-backup-r2-access"]
}

resource "aws_ssm_parameter" "pg_backup_r2_secret" {
  name             = "/fitnessbuddy/prod/pg-backup-r2-secret"
  type             = "SecureString"
  value_wo         = var.pg_backup_r2_secret
  value_wo_version = local.secret_versions["pg-backup-r2-secret"]
}

resource "aws_ssm_parameter" "grafana_cloud_token" {
  name             = "/fitnessbuddy/prod/grafana-cloud-token"
  type             = "SecureString"
  value_wo         = var.grafana_cloud_token
  value_wo_version = local.secret_versions["grafana-cloud-token"]
}