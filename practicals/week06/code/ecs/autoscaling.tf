resource "aws_appautoscaling_target" "taskoverflow" {
  max_capacity        = 4
  min_capacity        = 1
  resource_id         = "service/taskoverflow/taskoverflow"
  scalable_dimension  = "ecs:service:DesiredCount"
  service_namespace   = "ecs"
  
  depends_on = [ aws_ecs_service.taskoverflow ]
}

resource "aws_appautoscaling_policy" "todo-cpu" {
  name                = "todo-cpu"
  policy_type         = "TargetTrackingScaling"
  resource_id         = aws_appautoscaling_target.taskoverflow.resource_id
  scalable_dimension  = aws_appautoscaling_target.taskoverflow.scalable_dimension
  service_namespace   = aws_appautoscaling_target.taskoverflow.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type  = "ECSServiceAverageCPUUtilization"
    }
    target_value              = 20
  }
}