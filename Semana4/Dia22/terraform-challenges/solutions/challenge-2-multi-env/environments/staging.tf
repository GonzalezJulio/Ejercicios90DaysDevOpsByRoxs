# Generated for environment: staging

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "staging_instance" {
  ami           = "ami-12345678"
  instance_type = "t3.small"
  count         = 2
  tags = {
    Environment = "staging"
  }
}

resource "aws_db_instance" "staging_db" {
  allocated_storage    = "50"
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  name                 = "staging_db"
  username             = "admin"
  password             = "terraform123"
  skip_final_snapshot  = true
  backup_retention_period = 7
}
