########################## Authentication variables ###########################
variable "region" {
  default = "us-east-1"
}
#Theres variables are manually loaded into the env vars of the Gitlab project and are only available to admin users of said project
variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}
