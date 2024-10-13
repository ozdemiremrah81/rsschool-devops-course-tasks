# The RS School - AWS DevOps Course
## Task2 Documentation

This repository contains the terraform infrastructure as code configurations created for Task 2 of The RS School - AWS DevOps [Course](https://github.com/rolling-scopes-school/tasks/blob/master/devops/modules/1_basic-configuration/task_2.md)

You can easily use this setup to create or remove resources on your AWS environment for testing purposes.

### Directory & File information

- `.github/workflows/`: This folder contains YAML files defining Github Actions (gha) pipelines.

- `taskx`: For each task in the course, there will be specific folder to provide the details of the task.

- `taskx\screenshots`: This folder contains some screenshots to provide details about the completed parts of the task.

- `terraform` This folder contains all terraform files (.tf) which actually creates configured resources via gha pipeline.

- `\terraform\backend.tf` The configuration file for terraform backend configuration.

- `\terraform\*.tf` Configuration file for corresponding resource to create them on your AWS Cloud environment.

- `\terraform\main.tf` The main configuration file for core elements like providers.

- `\terraform\outputs.tf` This file contains outputs from your AWS Cloud environment.

- `\terraform\variables.tf` This file contains the variables for the Terraform project. This includes variable types, default values, and descriptions, which allow us to customize the deployment.

### How to use this infra in your environment:

-First, you have to create initial components manually in order to connect your github actions pipeline to your AWS environment. Please check all the "Steps completed" section below.
-Then clone the repository to your environment.
-Change .tf files and .yml file accordingly. You must adjust the region and resources that you want to create. In task2 it's creating
- a VPC with 10.1.0.0/21 CIDR
- 2 private 2 public subnets
- required routing tables (2) and their associations with subnets.
- t3.micro ec2 instances: bastion_host and private_instance1 (free eligable)
- an internet gateway
- an elastic ip and nat gateway
- security groups

-Currently you can run the pipeline;
- Manually whenever you need and your selected branch. Github [documentation](https://docs.github.com/en/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/manually-running-a-workflow).
- When you create pull request for main branch.

### Variables and Yaml details:

- `region` amazon region. (eu-north-1)
- `vpc_cidr_block` IP block that you want to create in CIDR notation. (10.1.0.0/21)
- `public and private subnets` Please define required subnets according to thi vpc cidr block.
- `AllowedIP` Only this public IP/range will allowed to connect bastion host. Replace with your IP range (office/home IP)

### Steps completed: (Initial setup to connect AWS infra in previous task)

AWS account created, additional (non root) account created

MFA activated for both

AWS cli has been configured to use nonroot user and tested.

github repo created as you can read this

AWS s3 bucket created (first one created manually to store state file, the second one created by gha pipeline.)
please read this [documentation](https://spacelift.io/blog/terraform-s3-backend:) to understand state file.

AWS dynomo  table created

Identity provider added for github on AWS with these details:

- https://token.actions.githubusercontent.com

- sts.amazonAWS.com

IAM Role Created manually. (First one created manually, the second one created by gha pipeline by using first one.)

IAM Role trust setting applied according to the [documentation](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)

I also added required permissions to gha pipeline.
id-token: write # This is required for requesting the JeWT2
contents: read  # This is required for actions/checkout

After this step you should be able to run the gha pipeline.

Terraform and screenshots folders are created to achieve more organised code structure.

Variables and s3 backend declared in seperate files. (variables.tf and backend.tf)

In gha pipeline, i added workflow_dispatch under the trigger section, in-order to run the pipeline manually when needed.

Since .tf files is not under the root directory, I added "working-directory: ./terraform" to jobs in gha pipeline.