# Generated for environment: dev

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "dev_instance" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"
  count         = 1
  tags = {
    Environment = "dev"
  }
}

resource "aws_db_instance" "dev_db" {
  allocated_storage    = "20"
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  name                 = "dev_db"
  username             = "admin"
  password             = "terraform123"
  skip_final_snapshot  = true
  backup_retention_period = 0
}
