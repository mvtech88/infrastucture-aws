remote_state {
  backend = "s3"
  generate = {
    path      = "state.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    profile = "mohit"
    role_arn = "arn:aws:iam::8331******:role/terraform"
    bucket = "mvlab-terraform-state"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "aws" {
  region  = "us-east-1"
  profile = "mohit"
  
  assume_role {
    session_name = "devlab"
    role_arn = "arn:aws:iam::833*******:role/terraform"
  }
}
EOF
}

