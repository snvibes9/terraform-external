{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Effect": "Allow"
        "Principal": "events.amazonaws.com"
      },
      "Action": "sts.AssumeRole"
      "Condition": {
          "StringEquals": {
            "aws:SourceArn": "arn:aws:events:us-east-1:xxxxx:rule/CodePipelineComplete",
            "aws:SourceAccount": "xxxxxx"
          }
      }
  ]
}
