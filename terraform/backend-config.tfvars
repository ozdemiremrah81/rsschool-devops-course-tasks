bucket         = "terraformstates-1"
key            = "state/terraform.tfstate"
region         = "eu-north-1"
encrypt        = true
dynamodb_table = "tf_lock"
#this file is unused right now. and if we continue to this branch, we can delete it, since its content has been added to main.tf.