terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name                      = "Group8-${var.env_name}-ASG"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.private_subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 60

  target_group_arns = [var.target_group_arn]

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Group8-${var.env_name}-Web"
    propagate_at_launch = true
  }
}

# Scale-out policy (CPU > 10%)
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "Group8-${var.env_name}-scale-out"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 60
}

# Scale-in policy (CPU < 5%)
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "Group8-${var.env_name}-scale-in"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 60
}
