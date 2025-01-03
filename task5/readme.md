
# The RS School - AWS DevOps Course
## Task5 Documentation

This part is explaining evaluation criterias for task5. If you need the infra setup details, please check the pages after the screenshots.

- I created the helm chart under the task5/helm/wordpress folder and deployed it with this command;
helm install my-wordpress .\wordpress

- In screenshot starting with1: You can see before the command there are no pods in the environment.
In same screenshot after running above command, I have wordpress and mysql pods. Also I listed helm deployment.

![1](https://github.com/ozdemiremrah81/rsschool-devops-course-tasks/blob/task5/task5/screenshots/1-before_and_after.png)


- In screenshot starting with2: You can see the wordpress is running on the ip address 51.21.129.190 and port 8080. You can check this setup is achieved via the helm chart's values file which includes following values: 

service:
  type: LoadBalancer
  port: 8080

![2](https://github.com/ozdemiremrah81/rsschool-devops-course-tasks/blob/task5/task5/screenshots/2-wordpress_withmy_public_ip.png)

- In screenshot starting with3: You can verify that this ip address belongs to my aws ec2 instance running k3s. (Its also deployed via github actions in task4)
- 
![3](https://github.com/ozdemiremrah81/rsschool-devops-course-tasks/blob/task5/task5/screenshots/3-wordpress_withmy_public_ip_2.png)


I also created a pipeline for the helm deployment, but the gha action fails.




## Steps completed to provide infrastructure for Task4
This repository contains the terraform infrastructure as code configurations created for Task 3 of The RS School - AWS DevOps [Course](https://github.com/rolling-scopes-school/tasks/blob/master/devops/modules/2_cluster-configuration/task_3.md)

You can easily use this setup to create or remove resources on your AWS environment for testing purposes.

Latest gha run for succesfully creating whole infrastructure with 17 resources:
https://github.com/ozdemiremrah81/rsschool-devops-course-tasks/actions/runs/11429083225/job/31795067827

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
- 2 private 1 public subnets
- required routing tables (2) and their associations with subnets.
- t3.micro ec2 instances: bastion_host, k3s master node and k3s agent (worker node) (free eligable)
- an internet gateway
- an elastic ip and nat gateway
- security groups

-Currently you can run the pipeline;
- Manually whenever you need and your selected branch. Github [documentation](https://docs.github.com/en/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/manually-running-a-workflow).
- When you create pull request for main branch.

### Variables and Yaml details:

- `region` amazon region. (eu-north-1)
- `vpc_cidr_block` IP block that you want to create in CIDR notation. (10.1.0.0/21)
- `public and private subnets` Please define required subnets according to the vpc cidr block. Current blocks are
  
  Private Subnet1: 10.1.1.0/24

  Private Subnet2: 10.1.2.0/24

  Public Subnet1:  10.1.6.0/24

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


### Steps completed: (These steps are required after resource creation.)


Preiously created pem file used to connect the k3s cluster.

## Download the kubectl config file from : 

scp -i app1_natgw_keypair.pem ubuntu@PUBLIC-IP:/etc/rancher/k3s/k3s.yaml k3s.yaml

update the server ip address in k3s.yaml
from:    server: https://127.0.0.1:6443
to:  server:https://PUBLIC-IP:6443

## to connect instances from bastion, copy pem file to bastion with this command:
scp -i app1_natgw_keypair.pem app1_natgw_keypair.pem ec2-user@PUBLIC-IP:~/

## to connect k3s instances from bastion host copy pem file to k3s instances:

scp -i app1_natgw_keypair.pem app1_natgw_keypair.pem ubuntu@k3sMasterNode:~/
scp -i app1_natgw_keypair.pem app1_natgw_keypair.pem ubuntu@k3sAgent:~/


## change the files permissions with this command otherwise this private key will be ignored:
chmod 600 app1_natgw_keypair.pem

ssh -i app1_natgw_keypair.pem ubuntu@k3sMasterNode

## get join token from master node: 
cat /var/lib/rancher/k3s/server/node-token

## ssh into agent node

## install k3s:
curl -sfL https://get.k3s.io | K3S_URL=https://k3sMasterNode:6443 K3S_TOKEN=<your token> sh -

## Label the Agent Node
kubectl label node 10.1.2.246 node-role.kubernetes.io/worker=worker

## Deploy sample app:
 kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml

