**please check previous tasks for infrastructure as code details.
# The RS School - AWS DevOps Course
## Task6 Documentation

This repository contains the terraform infrastructure as code configurations created for Task 3 of The RS School - AWS DevOps [Course](https://github.com/rolling-scopes-school/tasks/blob/master/devops/modules/2_cluster-configuration/task_3.md)

You can easily use this setup to create or remove resources on your AWS environment for testing purposes.

### Directory & File information

- `.github/workflows/`: This folder contains YAML files defining Github Actions (gha) pipelines.

- `taskx`: For each task in the course, there will be specific folder to provide the details of the task.
- 
- `taskx\helm`: Helm charts after task5.

- `taskx\screenshots`: This folder contains some screenshots to provide details about the completed parts of the task.

- `terraform` This folder contains all terraform files (.tf) which actually creates configured resources via gha pipeline.

- `\terraform\backend.tf` The configuration file for terraform backend configuration.

- `\terraform\*.tf` Configuration file for corresponding resource to create them on your AWS Cloud environment.

- `\terraform\main.tf` The main configuration file for core elements like providers.

- `\terraform\outputs.tf` This file contains outputs from your AWS Cloud environment.

- `\terraform\variables.tf` This file contains the variables for the Terraform project. This includes variable types, default values, and descriptions, which allow us to customize the deployment.
- jenkinsfile : Storing jenkins pipeline configuration and prepared webhooks for auto trigger on Jenkins.

## Steps for task6:
### 1.Create Docker Image and Store in ECR
- Docker image has been created via ./docker-compose.yaml in root directory. I used sample MERN stack application which consists of app (or client), server (or backend) and mongo db. 
![1](https://github.com/ozdemiremrah81/rsschool-devops-course-tasks/blob/task6-2/task6/screenshots/1.png)
  
- AWS access key created and AWS CLI configured to use it.
- Login to ECR registry with this command: aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 222634386594.dkr.ecr.eu-north-1.amazonaws.com
- Tagging the images: docker tag rsschool-devops-course-tasks-server:latest 222634386594.dkr.ecr.eu-north-1.amazonaws.com/emrah-server:v1
- Pushing the images: docker push 222634386594.dkr.ecr.eu-north-1.amazonaws.com/emrah-server:v1
- Ensure your K8s nodes can access the ECR repository by adjusting or creating a new instance profile for your EC2 instances: Previous steps was for local to ECR access. I also created IAM Role for K3s (running on ec2) to ECR access.  
![2](https://github.com/ozdemiremrah81/rsschool-devops-course-tasks/blob/task6-2/task6/screenshots/2.png)

- I added a step to my Github Actions pipeline to allow github runner access to k3s on aws ec2.
        - name: get runner ip address
        id: ip
        uses: haythem/public-ip@v1.2
      - name: allow_gha_on_aws_sg
        run: |
          aws ec2 authorize-security-group-ingress \
            --group-id $AWS_INSTANCE_SG_ID \
            --protocol tcp \
            --port 22 \
            --cidr ${{ steps.ip.outputs.ipv4 }}/32

### 2.Create Helm Chart
- Create a Helm chart for your application: Last Helm Chart is under task6-2/helm folder.
- Test the Helm chart manually from your local machine.
![3](https://github.com/ozdemiremrah81/rsschool-devops-course-tasks/blob/task6-2/task6/screenshots/3.png)

### 3.Store Artifacts in Git
-Store the Dockerfile and Helm chart in a git repository accessible to Jenkins: All files are stored on Github repository and I created credentials in Jenkins to access it.
![4](https://github.com/ozdemiremrah81/rsschool-devops-course-tasks/blob/task6-2/task6/screenshots/4.png)

### 4.Configure Jenkins Pipeline

- Create a Jenkins pipeline and store it as a Jenkinsfile in your main git repository: The jenkinsfile is under the root folder.
- Configure the pipeline to be triggered on each push event to the repository: I created a webhook as below. When I push the repository, it is triggering the Jenkins pipeline.
![5](https://github.com/ozdemiremrah81/rsschool-devops-course-tasks/blob/task6-2/task6/screenshots/5.png)

I created the pipeline as below and as you can see in the jenkinsfile, but it's currently failing.

![6](https://github.com/ozdemiremrah81/rsschool-devops-course-tasks/blob/task6-2/task6/screenshots/6.png)






