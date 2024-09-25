#Create a bucket

resource "aws_s3_bucket" "my-bucket" {
  bucket = var.bucketname
}

#Bucket ACL

resource "aws_s3_bucket_ownership_controls" "s3bucoc" {
  bucket = aws_s3_bucket.my-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "s3pab" {
  bucket = aws_s3_bucket.my-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "s3bucacl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.s3bucoc,
    aws_s3_bucket_public_access_block.s3pab,
  ]

  bucket = aws_s3_bucket.my-bucket.id
  acl    = "public-read"
}


#Insert object

resource "aws_s3_object" "object1" {
  bucket = aws_s3_bucket.my-bucket.id
  key    = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
  
}

resource "aws_s3_object" "object2" {
  bucket = aws_s3_bucket.my-bucket.id
  key    = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}


# Website config

resource "aws_s3_bucket_website_configuration" "s3wc" {
  bucket = aws_s3_bucket.my-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  depends_on = [ aws_s3_bucket_acl.s3bucacl]

  }
