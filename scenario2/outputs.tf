output "vpc_ids" {
  value = {
    for k, m in module.vpc : k => m.vpc_id
  }
}

output "public_subnet_ids" {
  value = {
    for k, m in module.vpc : k => m.public_subnet_ids
  }
}

output "private_subnet_ids" {
  value = {
    for k, m in module.vpc : k => m.private_subnet_ids
  }
}
