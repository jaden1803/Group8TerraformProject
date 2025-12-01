variable "ami_id" {
  description = "AMI to use for web instances"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2 (ví dụ)
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
  default     = "vockey"
}

variable "web_bucket_name" {
  description = "S3 bucket for dev web content"
  type        = string
  default     = "group8-dev-web-bucket"
}
