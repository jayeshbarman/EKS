terraform {
  backend "s3" {
    bucket         = "<REPLACE_WITH_YOUR_REMOTESTATE_BUCKETNAME>"
    dynamodb_table = "<REPLACE_WITH_YOUR_DYNAMODB_TABLENAME>"
    key            = "Mumbai"
    region         = "ap-south-1"
    encrypt        = true
  }
}
