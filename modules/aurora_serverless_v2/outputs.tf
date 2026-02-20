output "cluster_endpoint" {
  value = aws_rds_cluster.this.endpoint
}

output "cluster_reader_endpoint" {
  value = aws_rds_cluster.this.reader_endpoint
}

output "db_security_group_id" {
  value = aws_security_group.db.id
}