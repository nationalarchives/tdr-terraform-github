resource "aws_iam_policy" "github_actions_deploy_lambda_policy" {
  name = "TDRGithubActionsDeployLambda${title(var.environment)}"
  policy = templatefile("${path.module}/templates/iam_policy/deploy_lambda_github_actions.json.tpl", {
    account_id = var.account_id, environment = var.environment, region = var.region
  })
}

resource "aws_iam_role" "github_actions_role" {
  name = "TDRGithubActionsDeployLambda${title(var.environment)}"
  assume_role_policy = templatefile("${path.module}/templates/iam_role/github_assume_role.json.tpl", {
    account_id = var.account_id, repo_name = "tdr-*"
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_deploy_lambda_policy_attach" {
  policy_arn = aws_iam_policy.github_actions_deploy_lambda_policy.arn
  role       = aws_iam_role.github_actions_role.id
}
