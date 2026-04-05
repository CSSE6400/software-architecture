resource "aws_autoscaling_group" "todo" {
  name = "todo"
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 4
  min_size           = 1

  launch_template {
    id      = aws_launch_template.todo.id
    version = "$Latest"
  }
}


#### DOWN #####################################################################

resource "aws_autoscaling_policy" "todo_scale_down" {
  name                   = "todo_scale_down"
  autoscaling_group_name = aws_autoscaling_group.todo.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "todo_scale_down" {
  alarm_description   = "Monitors CPU utilization for Todo"
  alarm_actions       = [aws_autoscaling_policy.todo_scale_down.arn]
  alarm_name          = "todo_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "10"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.todo.name
  }
}


#### UP ######################################################################

resource "aws_autoscaling_policy" "todo_scale_up" {
  name                   = "todo_scale_up"
  autoscaling_group_name = aws_autoscaling_group.todo.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "todo_scale_up" {
  alarm_description   = "Monitors CPU utilization for Todo"
  alarm_actions       = [aws_autoscaling_policy.todo_scale_up.arn]
  alarm_name          = "todo_scale_up"
  comparison_operator = "GreaterThanThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "20"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.todo.name
  }
}