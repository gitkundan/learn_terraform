module "networking" {
  source = "../core_modules/networking"

  environment = "prod"

  vpc_cidr_block        = var.vpc_cidr_block
  public_subnet_count   = var.public_subnet_count
  private_subnet_count  = var.private_subnet_count
  subnet_newbits        = var.subnet_newbits
  public_subnet_offset  = var.public_subnet_offset
  private_subnet_offset = var.private_subnet_offset
  azs                   = var.azs
}

module "webserver" {
  source = "../core_modules/webserver"

  environment   = "prod"
  vpc_id        = module.networking.vpc_id
  subnet_ids    = module.networking.private_subnet_ids
  instance_type = var.instance_type
  min_size      = var.min_size
  max_size      = var.max_size
  server_port   = var.server_port
}