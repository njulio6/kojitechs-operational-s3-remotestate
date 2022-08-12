
# s3 
resource "aws_s3_bucket" "state_bucket" {
  count = length(var.bucket_name)

  bucket = var.bucket_name[count.index]# create variable, 
}

resource "aws_s3_bucket_acl" "state_bucket_acl" {
  count = length(var.bucket_name)
  bucket = aws_s3_bucket.state_bucket[count.index].id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "state_bucket_versioning" {
  count = length(var.bucket_name)
  bucket = aws_s3_bucket.state_bucket[count.index].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "terraform-state-lock"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  
}