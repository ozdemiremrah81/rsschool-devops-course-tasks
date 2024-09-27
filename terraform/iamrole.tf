resource "aws_iam_role" "GithubActionsRole2" {
  name = "GithubActionsRole2"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        #Sid    = ""
        Principal = {
          Federated = "arn:aws:iam::222634386594:oidc-provider/token.actions.githubusercontent.com"
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:ozdemiremrah81/*"
          }
        }
      }
    ]
  })
}
