resource "aws_key_pair" "consul-demo" {
  key_name = "${local.name_prefix}-key"

  public_key = file(
    pathexpand("~/Desktop/aws_files/hein_linux_rsa_key.pub")
  )

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-key"

  })
}