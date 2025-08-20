Steps completed:

aws account created, additional (non root) account created

mfa activated for both

aws cli has been configured to use nonroot user and tested.

github repo created as you can read this

https://spacelift.io/blog/terraform-s3-backend:
aws s3 bucket created
aws dynomo  table created
test terraform file applied with success, but the state file did not uploaded to s3 bucket.

https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
adding identity provider for github on aws.
https://token.actions.githubusercontent.com
sts.amazonaws.com

testing dependency reviews



