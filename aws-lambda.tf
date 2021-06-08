resource "aws_lambda_function" "image_resizer" {
    s3_bucket = 
    s3_key = 
    s3_object_version = 
    function_name = "Substrakt-Tachyon-Image-Resizer-Stack"
    role = aws_iam_role.b-lam-role.arn
    handler = "lambda-handler.handler"
    runtime = "nodejs10.x"
    timeout = 60
    memory_size = 256
    environment {
        variables = {
            S3_BUCKET = aws_s3_bucket.assets.bucket
            S3_REGION = 
            S3_AUTHENTICATED_REQUEST = false
        }
    }
}
