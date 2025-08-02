resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2b"
}

resource "aws_security_group" "rdp_sg" {
  name   = "${var.project_name}-rdp"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [var.allowed_rdp_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "private_subnet_group" {
  # שם ייחודי כדי למנוע קונפליקט
  name       = "private-db-subnet-group-${var.project_name}"
  subnet_ids = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]
}

resource "aws_db_instance" "postgres" {
  identifier             = "${var.project_name}-rds"
  engine                 = "postgres"
  engine_version         = "13.12"
  instance_class         = "db.t3.small"
  allocated_storage      = 20

  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.rdp_sg.id]

  skip_final_snapshot  = true
  publicly_accessible  = false

  db_subnet_group_name = aws_db_subnet_group.private_subnet_group.name
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "random_id" "ecr_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "geojson_bucket" {
  bucket        = "${var.project_name}-geojson-input-${random_id.bucket_suffix.hex}"
  force_destroy = true
}

resource "aws_ecr_repository" "ecr-repo" {
  name = "${var.project_name}-repo-${random_id.ecr_suffix.hex}"
}

