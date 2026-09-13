resource "aws_iam_role" "consul-demo-ec2" {
  name = "${local.name_prefix}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ec2-role"
    }
  )
}


resource "aws_iam_policy" "consul-demo-s3-read" {
  name        = "${local.name_prefix}-s3-read-policy"
  description = "Allow Consul demo EC2 instances to download application binaries from S3"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject"
        ]

        Resource = "${aws_s3_bucket.consul-demo.arn}/*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "consul-demo-s3-read" {
  role       = aws_iam_role.consul-demo-ec2.name
  policy_arn = aws_iam_policy.consul-demo-s3-read.arn
}



resource "aws_iam_role_policy_attachment" "consul-demo-ssm" {
  role       = aws_iam_role.consul-demo-ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_instance_profile" "consul-demo-ec2" {
  name = "${local.name_prefix}-ec2-instance-profile"
  role = aws_iam_role.consul-demo-ec2.name

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ec2-instance-profile"
    }
  )
}