resource "aws_security_group" "db" {
  name        = "${var.name_prefix}-db-sg"
  description = "Aurora SG (allow MySQL from app SG only)"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from app"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-db-sg" })
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-db-subnet"
  subnet_ids = var.db_subnet_ids

  tags = merge(var.tags, { Name = "${var.name_prefix}-db-subnet" })
}

resource "aws_rds_cluster" "this" {
  cluster_identifier = "${var.name_prefix}-aurora"
  engine             = "aurora-mysql"
  engine_version = var.engine_version != "" ? var.engine_version : null
  database_name      = var.db_name

  master_username = var.master_username
  master_password = var.master_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db.id]

  backup_retention_period = 3
  preferred_backup_window = "19:00-20:00" # JST 4:00-5:00 くらい（好みで変更OK）

  storage_encrypted = true
  deletion_protection = false
  skip_final_snapshot  = true

  serverlessv2_scaling_configuration {
    min_capacity = var.serverless_min_acu
    max_capacity = var.serverless_max_acu
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-aurora" })
}

# Serverless v2 は "aws_rds_cluster_instance" が必須（instance class は db.serverless）
resource "aws_rds_cluster_instance" "writer" {
  identifier         = "${var.name_prefix}-aurora-writer-1"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version

  publicly_accessible = false

  tags = merge(var.tags, { Name = "${var.name_prefix}-aurora-writer-1" })
}