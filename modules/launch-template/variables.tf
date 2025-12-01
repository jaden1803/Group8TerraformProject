variable "env_name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "web_sg_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "bucket_name" {
  description = "S3 bucket where index.html and images are stored"
  type        = string
}
