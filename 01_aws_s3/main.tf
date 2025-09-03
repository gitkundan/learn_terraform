# Note : AWS credentials and region will come after export credentials done
# Bucket name and tags are optional
# use tf apply -refresh=false as to referesh tf state aws object lock configuration is called which is blocked
provider "aws"{
    region = "us-east-1"

}
# The 'bucket' argument is omitted as terraform will auto-generate
# resource "aws_s3_bucket" "finance" {
# }

#use random_uuid to generate UUID for bucket names
resource "random_uuid" "id" {}

# if using bucket_prefix tf will auto-generate the name of bucket
resource "aws_s3_bucket" "finance" {
    bucket_prefix = "etl009"
    # bucket = "${random_uuid.id.result}"
}

resource "aws_s3_object" "finance-2020" {
    bucket = aws_s3_bucket.finance.id
    key="example.txt"
    source="example.txt"
}

# TODO : define a policy using heredoc syntax
# resource "aws_s3_bucket_policy" "finance-policy" {
#     bucket = aws_s3_bucket.finance.id
#     policy = <<EOF
#     {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#         "Resource":"arn:aws:s3:::${aws_s3_bucket.finance.id}/*",
#         "Effect": "Allow",
#         "Action": [
#             "s3:*"
#         ],
#         }
#     ]
#     }
# EOF
# }

# print variable names
output "bucket_name" {
    description = "bucket created"
    value = aws_s3_bucket.finance.id
}

#output object that was uploaded into the bucket
output "object_url" {
    description = "object uploaded to bucket"
    value = "s3://${aws_s3_bucket.finance.id}/${aws_s3_object.finance-2020.key}"
}