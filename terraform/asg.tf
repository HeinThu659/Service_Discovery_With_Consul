resource "aws_launch_template" "dashboard" {
  name_prefix   = "${local.name_prefix}-dashboard-"
  image_id      = "ami-0794a632d5c1058bf"
  instance_type = var.instance_type
  monitoring {
    enabled = true
  }

  key_name = aws_key_pair.consul-demo.key_name

  vpc_security_group_ids = [
    aws_security_group.consul-demo-dashboard.id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.consul-demo-ec2.name
  }

  user_data = base64encode(local.dashboard_user_data)

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.common_tags,
      {
        Name = "${local.name_prefix}-dashboard"
      }
    )
  }
}



resource "aws_autoscaling_group" "dashboard" {
  name = "${local.name_prefix}-dashboard-asg"

  min_size         = 1
  desired_capacity = 1
  max_size         = 2

  vpc_zone_identifier = [
    aws_subnet.consul-demo-private["private_a_dashboard"].id,
    aws_subnet.consul-demo-private["private_c_dashboard"].id
  ]

  target_group_arns = [
    aws_lb_target_group.dashboard.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.dashboard.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-dashboard"
    propagate_at_launch = true
  }
}


resource "aws_launch_template" "counting" {
  name_prefix   = "${local.name_prefix}-counting-"
  image_id      = "ami-0794a632d5c1058bf"
  instance_type = var.instance_type
  monitoring {
    enabled = true
  }

  key_name = aws_key_pair.consul-demo.key_name

  vpc_security_group_ids = [
    aws_security_group.consul-demo-counting.id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.consul-demo-ec2.name
  }

  user_data = base64encode(local.counting_user_data)

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.common_tags,
      {
        Name = "${local.name_prefix}-counting"
      }
    )
  }
}


resource "aws_autoscaling_group" "counting" {
  name = "${local.name_prefix}-counting-asg"

  min_size         = 1
  desired_capacity = 1
  max_size         = 2

  vpc_zone_identifier = [
    aws_subnet.consul-demo-private["private_a_counting"].id,
    aws_subnet.consul-demo-private["private_c_counting"].id
  ]

  target_group_arns = [
    aws_lb_target_group.counting.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.counting.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-counting"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "dashboard_cpu" {
  name                   = "${local.name_prefix}-dashboard-cpu-scaling"
  autoscaling_group_name = aws_autoscaling_group.dashboard.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}

resource "aws_autoscaling_policy" "counting_cpu" {
  name                   = "${local.name_prefix}-counting-cpu-scaling"
  autoscaling_group_name = aws_autoscaling_group.counting.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}