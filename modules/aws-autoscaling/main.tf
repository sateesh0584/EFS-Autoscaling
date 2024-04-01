# Creating Launch template for Web tier AutoScaling Group
resource "aws_launch_template" "Web-LC" {
  name = var.launch-template-name
  image_id = var.ec2ami_id
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
    }
  }
  instance_type = "t2.micro"
  key_name                    = var.key_name
  vpc_security_group_ids  = var.vpc_security_group_ids
}

resource "aws_autoscaling_group" "Web-ASG" {
  name                      = var.asg-name
  launch_template {
    id      = aws_launch_template.Web-LC.id
    version = aws_launch_template.Web-LC.latest_version
  }
  min_size                  = 1
  max_size                  = 2
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier       = [var.subnet_id]  

  force_delete              = true
  tag {
    key                      = "Name"
    value                    = "Web-ASG"
    propagate_at_launch      = true
  }
}

resource "aws_autoscaling_policy" "web-custom-cpu-policy" {
  name                   = "custom-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.Web-ASG.id
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 60
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "web-custom-cpu-alarm" {
  alarm_name          = "custom-cpu-alarm"
  alarm_description   = "alarm when cpu usage increases"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = "70"

  dimensions = {
    "AutoScalingGroupName" : aws_autoscaling_group.Web-ASG.name
  }
  actions_enabled = true

  alarm_actions = [aws_autoscaling_policy.web-custom-cpu-policy.arn]
}

resource "aws_autoscaling_policy" "web-custom-cpu-policy-scaledown" {
  name                   = "custom-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.Web-ASG.id
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 60
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "web-custom-cpu-alarm-scaledown" {
  alarm_name          = "custom-cpu-alarm-scaledown"
  alarm_description   = "alarm when cpu usage decreases"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = "50"

  dimensions = {
    "AutoScalingGroupName" : aws_autoscaling_group.Web-ASG.name
  }
  actions_enabled = true

  alarm_actions = [aws_autoscaling_policy.web-custom-cpu-policy-scaledown.arn]
}
