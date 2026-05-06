locals {
  instance_type = "t3.micro"

  volume_size = terraform.workspace == "prod" ? 30 : 20

  common_tags = {
    Project     = var.project_name
    Environment = terraform.workspace
    ManagedBy   = "Terraform"
    Week        = "Week16Lab"
    UpdatedBy   = "GitHubActions"
  }
}