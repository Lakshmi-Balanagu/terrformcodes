# variables.tf
variable "rds_master_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true

}
provider "aws" {
  region = "eu-north-1"
}
resource "aws_secretsmanager_secret" "rds_password" {
  name = "rds/master/password"
}

resource "aws_secretsmanager_secret_version" "rds_password_version" {
  secret_id     = aws_secretsmanager_secret.rds_password.id
  secret_string = var.rds_master_password
}
# terrafprm apply -var="password" -auto-apply
