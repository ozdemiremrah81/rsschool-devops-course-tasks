How to use this infra in your environment;

-First, you have to create initial components manually in order to connect your github actions pipeline to your aws environment.
-Then clone the repository to your environment.
-Change .tf files accordingly. You must adjust the region and resources that you want to create. Currently it's creating
1)a VPC with 10.1.0.0/16 CIDR
2)a IAM Role with...
3)a Bucket

-Currently you can run the pipeline
a) Manually whenever you need and your selected branch.
b) When you create pull request for main branch.

Steps completed:

aws account created, additional (non root) account created

mfa activated for both

aws cli has been configured to use nonroot user and tested.

github repo created as you can read this

https://spacelift.io/blog/terraform-s3-backend:

aws s3 bucket created (first one created manually to store state file, the second one created by gha pipeline.

aws dynomo  table created

https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services

identity provider added for github on aws:

https://token.actions.githubusercontent.com

sts.amazonaws.com

IAM Role Created manually. (First one created manually, the second one created by gha pipeline by using first one.)

IAM Role trust setting applied according to the documentation. 
https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services

I also added required permissions to gha pipeline.
id-token: write # This is required for requesting the JeWT2
contents: read  # This is required for actions/checkout

terraform and screenshots folders are created to achieve more organised code structure.

variables and s3 backend declared in seperate files. (variables.tf and backend.tf)

in gha pipeline, i added workflow_dispatch under the trigger section, in-order to run the pipeline manually when needed.

Since .tf files is not under the root directory, i added "working-directory: ./terraform" to jobs in gha pipeline.























