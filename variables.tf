variable "app_name" {
  description = "Name of the app (lowercase letters and hyphens only)"
  validation {
    # regex(...) will fail if it cannot find a match
    # lowercase letters and hyphens only
    condition     = can(regex("^[a-z]+(-[a-z]+)*$", var.app_name))
    error_message = "The app name may only contain lowercase letters and hyphens."
  }
}

variable "domain_name" {
  description = "Domain name for use with the certificate created by ACM. Format domain.com"
}

variable "iam_policy_arn" {
  description = "IAM policies to be attached to user"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator",
    "arn:aws:iam::aws:policy/CloudFrontFullAccess",
    "arn:aws:iam::aws:policy/IAMUserChangePassword",
    "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator",
    "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess",
    "arn:aws:iam::aws:policy/AWSLambda_FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSCertificateManagerFullAccess"
  ]
}
