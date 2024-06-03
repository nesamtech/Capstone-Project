# create an sns topic
resource "aws_sns_topic" "user_updates" {
  name      = "wordpress-sns-topic"
}

# create an sns topic subscription
resource "aws_sns_topic_subscription" "notification_topic" {
  topic_arn = aws_sns_topic.user_updates.arn 
  protocol  = "email"
  endpoint  = "samntochukwu@gmail.com"
}