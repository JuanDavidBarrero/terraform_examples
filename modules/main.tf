module "module1" {
  source = "./folder1"
}

module "module2" {
  source = "./folder2"
}


output "hello_from_module1" {
  value = module.module1.message
}

output "hello_from_module2" {
  value = module.module2.message
}