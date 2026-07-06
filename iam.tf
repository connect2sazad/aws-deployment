# add ec2 role policy
resource "aws_iam_role" "webserver_role" {
  name = "s3ec2_trust_policy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

# policy to allow my server only to access s3 bucket
resource "aws_iam_policy" "webserver_allow_s3_policy" {
  name = "server-allow-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = aws_s3_bucket.webserver_s3_bucket.arn
      },

      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = "${aws_s3_bucket.webserver_s3_bucket.arn}/*"
      }

    ]
  })
}

resource "aws_s3_bucket_policy" "allow_public_folder" {
  bucket = aws_s3_bucket.webserver_s3_bucket.id

  depends_on = [ aws_s3_bucket_public_access_block.webserver_s3_bucket_public_access ]

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.webserver_s3_bucket.arn}/public/*"
      }
    ]
  })
}


# attaching the policy to the role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.webserver_role.name
  policy_arn = aws_iam_policy.webserver_allow_s3_policy.arn
}

# create instance profile
# this thing is automatically handled by aws console
# but in case of terraform, we need to handle it
# as terraform treats every aws thing as a resource
resource "aws_iam_instance_profile" "webserver_profile" {
  name = "webserver_profile"
  role = aws_iam_role.webserver_role.name
}