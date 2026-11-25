resource "aws_budgets_budget" "monthly" {
  budget_type  = "COST"
  limit_amount = "37.0"
  limit_unit   = "USD"
  metrics      = ["UnblendedCost"]
  name         = "fitnessbuddy"
  time_unit    = "MONTHLY"
  filter_expression {
    not {
      dimensions {
        key    = "RECORD_TYPE"
        values = ["Credit", "Refund"]
      }
    }
  }
  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.alert_email]
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
  }
  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.alert_email]
    threshold                  = 50
    threshold_type             = "PERCENTAGE"
  }
  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.alert_email]
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
  }
  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.alert_email]
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
  }
}



resource "aws_cloudwatch_metric_alarm" "recover" {
  for_each = {
    "server" = aws_instance.server.id
    "agent"  = aws_instance.agent.id
  }
  alarm_name  = "fitnessbuddy-${each.key}-system-check"
  namespace   = "AWS/EC2"
  metric_name = "StatusCheckFailed_System"
  dimensions = {
    "InstanceId" = each.value
  }
  statistic           = "Maximum"
  period              = 60
  evaluation_periods  = 2
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 1

  alarm_actions = ["arn:aws:automate:${local.region}:ec2:recover"]

}