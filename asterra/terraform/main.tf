resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private_subnet" {
    vpc_id            = aws_vpc.main.id 
    cidr_block        = "10.0.1.0/24"     
}

resource "aws_security_group" "rdp_sg" {
    name              = "${var.project_name}-rdp"
    vpc_id            = aws_vpc.main.id 

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

resource "aws_db_instance" "postgres" {
    identifier              = "${var.project_name}-rds"
    engine                  = "postgres"
    engine_version          = "13.4"
    instance_class          = 20
    name                    = var.db_name
    username                = var.db_username
    password                = var.db_password  
    vpc_security_group_ids  = [aws_security_group.rdp_sg.id]
    skip_final_snapshot     = true 
    publicly_accessible     = false
    db_subnet_group_name    = aws_db_subnet_group.private_subnet_group.name
}

resource "aws_db_subnet_group" "private_subnet_group" {
    name        = "private-db-subnet-group"
    subnet_ids  = [aws_subnet.private_subnet.id] 
}

resource "aws_s3_bucket" "geojson_bucket" {
    bucket          = "${var.project_name}-geojson-input"
    force_destroy   = true  
}

resource "aws_ecr_repository" "ecr-repo" {
    name            = "${var.project_name}-repo"
}
