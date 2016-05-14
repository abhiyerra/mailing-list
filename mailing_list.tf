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


resource "aws_lambda_function" "workflow_lambda" {
  filename = "output.zip"
  function_name = "opszero_mailing_list_workflow"
  role = "${aws_iam_role.iam_for_lambda.arn}"
  handler = "workflow.handler"
  source_code_hash = "${base64sha256(file("output.zip"))}"
}

resource "aws_cloudwatch_event_rule" "every_hour" {
  name = "every-hour"
  description = "Fires every hour"
  schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "workflow_lambda_every_hour" {
  rule = "${aws_cloudwatch_event_rule.every_hour.name}"
  target_id = "workflow_lambda"
  arn = "${aws_lambda_function.workflow_lambda.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_workflow_lambda" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.workflow_lambda.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.every_hour.arn}"
}
