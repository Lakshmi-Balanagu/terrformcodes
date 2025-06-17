variable "regions" {
  default = ["ap-south-1", "us-east-1", "eu-west-1"]
}

resource "aws_cloudwatch_dashboard" "example" {
  for_each = toset(var.regions)

  provider = aws

  dashboard_name = "dashboard-${each.key}"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "text",
        properties = {
          markdown = "# Dashboard for ${each.key}"
        }
      }
    ]
  })
}
