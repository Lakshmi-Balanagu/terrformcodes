resource "aws_cloudwatch_dashboard" "dashboard" {
  provider       = aws
  dashboard_name = "dashboard-${var.region}"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "text",
        x    = 0,
        y    = 0,
        width = 24,
        height = 3,
        properties = {
          markdown = "## Dashboard for ${var.region}"
        }
      }
    ]
  })
}
