terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

resource "aws_launch_template" "this" {
  name_prefix   = "Group8-${var.env_name}-LT-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = var.instance_profile_name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.web_sg_id]
  }

  user_data = base64encode(
    templatefile("${path.module}/user_data.sh", {
      bucket_name = var.bucket_name
    })
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Group8-${var.env_name}-Web"
      Env  = var.env_name
      Tier = "web"
    }
  }
}
