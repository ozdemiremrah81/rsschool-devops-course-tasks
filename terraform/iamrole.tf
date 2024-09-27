data "aws_iam_role" "existing_role" {
  name = "GithubActionsRole"
}

resource "aws_iam_role" "GithubActionsRole" {
  count = length(data.aws_iam_role.existing_role.id) == 0 ? 1 : 0

  name = "GithubActionsRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
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
