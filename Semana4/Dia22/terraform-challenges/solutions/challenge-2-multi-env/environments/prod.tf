# Generated for environment: prod

provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "prod_instance" {
  ami           = "ami-12345678"
  instance_type = "t3.large"
  count         = 3
  tags = {
    Environment = "prod"
  }
}

resource "aws_db_instance" "prod_db" {
  allocated_storage    = "100"
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  name                 = "prod_db"
  username             = "admin"
  password             = "terraform123"
  skip_final_snapshot  = true
  backup_retention_period = 7
}
