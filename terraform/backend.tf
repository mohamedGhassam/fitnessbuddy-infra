terraform {
  backend "s3" {
    bucket                      = "fitnessbuddy-tfstate"
    key                         = "prod/terraform.tfstate"
    region                      = "auto"
    use_path_style              = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    profile                     = "r2"
    skip_s3_checksum            = true
    use_lockfile                = true
    endpoints = {
      s3 = "https://3d3bdbf16de0e8314afade0749d5dfbd.r2.cloudflarestorage.com"
    }
  }
}