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
  name       = "private-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]
}

resource "aws_rds_cluster" "postgres_cluster" {
  cluster_identifier      = "${var.project_name}-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = var.db_engine_version
  master_username         = var.db_username
  master_password         = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.private_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rdp_sg.id]
  skip_final_snapshot     = true
  storage_encrypted       = true

  serverlessv2_scaling_configuration {
    min_capacity = 1
    max_capacity = 3

}

resource "aws_rds_cluster_instance" "postgres_instance" {
  count                   = var.db_instance_count
  identifier              = "${var.project_name}-instance-${count.index + 1}"
  cluster_identifier      = aws_rds_cluster.postgres_cluster.id
  instance_class          = var.db_instance_class
  engine                  = aws_rds_cluster.postgres_cluster.engine
  engine_version          = aws_rds_cluster.postgres_cluster.engine_version
  publicly_accessible     = false
}

resource "aws_s3_bucket" "geojson_bucket" {
  bucket        = "${var.project_name}-geojson-input"
  force_destroy = true
}

resource "aws_ecr_repository" "ecr-repo" {
  name = "${var.project_name}-repo"
}
