# Create the REST APi
resource "aws_api_gateway_rest_api" "tachyon" {
  name = "Tachyon"
  endpoint_configuration {
    types = ["EDGE"]
  }
}

# Create the API Gateway Resource
resource "aws_api_gateway_resource" "tachyon-api-resource" {
  rest_api_id = aws_api_gateway_rest_api.tachyon.id
  parent_id   = aws_api_gateway_rest_api.tachyon.root_resource_id
  path_part   = "{proxy+}"
}

# Create the API Gateway Method
resource "aws_api_gateway_method" "tachyon-api-method" {
  rest_api_id   = aws_api_gateway_rest_api.tachyon.id
  resource_id   = aws_api_gateway_resource.tachyon-api-resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Create the HTTP Method Integration for the API Gateway
resource "aws_api_gateway_integration" "tachyon-api-method-integration" {
  rest_api_id             = aws_api_gateway_rest_api.tachyon.id
  resource_id             = aws_api_gateway_resource.tachyon-api-resource.id
  http_method             = aws_api_gateway_method.tachyon-api-method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  content_handling        = "CONVERT_TO_BINARY"
  uri                     = "aws_lambda_function.LAMBDA_FUNCTION_URI_HERE.invoke_arn"
}

# Create the API Gateway Deployment. A deployment is a snapshot of the REST API configuration.
resource "aws_api_gateway_deployment" "tachyon-api-deployment" {
  rest_api_id = aws_api_gateway_rest_api.tachyon.id
  description = "Production"
  depends_on = [
    aws_api_gateway_method.tachyon-api-method
  ]
}

# Create the API Gateway Stage. A stage is a named reference to a deployment.
resource "aws_api_gateway_stage" "tachyon-api-gateway-stage" {
  deployment_id = aws_api_gateway_deployment.tachyon-api-deployment.id
  rest_api_id   = aws_api_gateway_rest_api.tachyon.id
  stage_name    = "Prod"
}
