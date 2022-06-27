resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm_profile"
  role = aws_iam_role.ssm_role.name
}
resource "aws_iam_role_policy_attachment" "ec2_ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = data.aws_iam_policy.ec2_ssm.arn
}
resource "aws_iam_role_policy_attachment" "ec2_describe_lb_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.ec2_describe_lb.arn
}
data "aws_iam_policy" "ec2_ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role" "ssm_role" {
  name               = "ssm_role"
  path               = "/"
  assume_role_policy = file("${path.module}/ec2_assume_role.json")
}
resource "aws_iam_policy" "ec2_describe_lb" {
  policy = "${file("ec2_describe_lb.json")}"
}
