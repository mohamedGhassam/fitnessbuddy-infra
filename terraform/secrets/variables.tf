variable "jwt_secret" {
  type      = string
  sensitive = true
  ephemeral = true
}

variable "usda_api_key" {
  type      = string
  sensitive = true
  ephemeral = true
}

variable "youtube_api_key" {
  type      = string
  sensitive = true
  ephemeral = true
}

variable "r2_access" {
  type      = string
  sensitive = true
  ephemeral = true
}

variable "r2_secret" {
  type      = string
  sensitive = true
  ephemeral = true
}

variable "pg_backup_r2_access" {
  type      = string
  sensitive = true
  ephemeral = true
}

variable "pg_backup_r2_secret" {
  type      = string
  sensitive = true
  ephemeral = true
}

variable "grafana_cloud_token" {
  type      = string
  sensitive = true
  ephemeral = true
}

variable "cloudflare_tunnel_token" {
  type      = string
  sensitive = true
  ephemeral = true
}