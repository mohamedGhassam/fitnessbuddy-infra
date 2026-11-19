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
