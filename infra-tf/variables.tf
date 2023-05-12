variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ecr_repo_url" {
  description = "URL of the ECR repository"
  type        = string
  default     = "your-ecr-repo/image:tag"
}
