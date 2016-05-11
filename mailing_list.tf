resource "aws_dynamodb_table" "store_transactions" {
  name = "opsZeroMailingList"
  read_capacity = 2
  write_capacity = 2
  hash_key = "Email"
  attribute {
    name = "Email"
    type = "S"
  }
}

resource "aws_iam_role_policy" "mailing_list_policy" {
  name = "opsZeroMailingListPolicy"
  role = "${aws_iam_role.iam_for_lambda.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem"
            ],
            "Resource": "arn:aws:dynamodb:us-west-2:*:table/opsZeroMailingList"
        }
    ]
}
EOF
}

resource "aws_iam_role" "iam_for_lambda" {
    name = "iam_for_lambda"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "opszero_lambda" {
  filename = "output.zip"
  function_name = "opszero_mailing_list"
  role = "${aws_iam_role.iam_for_lambda.arn}"
  handler = "index.handler"
  source_code_hash = "${base64sha256(file("output.zip"))}"
}
