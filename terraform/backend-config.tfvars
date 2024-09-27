bucket         = "terraformstates-1"
key            = "state/terraform.tfstate"
region         = "eu-north-1"
encrypt        = true
dynamodb_table = "tf_lock"