variable "env_name" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  description = "Map of AZ to CIDR for public subnets"
  type        = map(string)
}

variable "private_subnet_cidrs" {
  description = "Map of AZ to CIDR for private subnets"
  type        = map(string)
}
