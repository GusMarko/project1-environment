# S3 bucket  
resource "aws_s3_bucket" "s3" {
  bucket = "project1-environment-s3-spotify-website"

  tags = {
    Name        = "Project-S3-Bucket-Cloudfront-Hosting"
    Environment = "${var.env}"
  }
}

# Website configuration
resource "aws_s3_bucket_website_configuration" "s3_web" {
  bucket = aws_s3_bucket.s3.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Denie public access / Cloudfront enables
resource "aws_s3_bucket_public_access_block" "s3" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket policy document for allowing cloudfront access
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cdn.arn]
    }
  }
}

# s3 bucket policy
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

resource "aws_s3_bucket_object" "index" {
    bucket = "project1-environment-s3-spotify-website"
    key = "index.html"
    depends_on = [
    aws_s3_bucket.spotify_website
  ]
    source = "../website/index.html"
    etag = filemd5("../website/index.html")
}

resource "aws_s3_bucket_object" "style" {
    bucket = "project1-environment-s3-spotify-website"
    key = "style.css"
    depends_on = [
    aws_s3_bucket.spotify_website
  ]
    source = "../website/style.css"
    etag = filemd5("../website/style.css")
}

resource "aws_s3_bucket_object" "script" {
    bucket = "project1-environment-s3-spotify-website"
    key = "script.js"
    depends_on = [
    aws_s3_bucket.spotify_website
  ]
    source = "../website/script.js"
    etag = filemd5("../website/script.js")
}

resource "aws_s3_bucket_object" "error" {
    bucket = "project1-environment-s3-spotify-website"
    key = "error.html"
    depends_on = [
    aws_s3_bucket.spotify_website
  ]
    source = "../website/error.html"
    etag = filemd5("../website/error.html")
}