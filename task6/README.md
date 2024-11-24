## Steps for task6:
### 1.Create Docker Image and Store in ECR
- Docker image has been created via ./docker-compose.yaml in root directory. I used sample MERN stack application which consists of app (or client), server (or backend) and mongo db. 
  ![alt text](<Store the Docker image in an AWS ECR repository.png>)
- AWS access key created and AWS CLI configured to use it.
- Login to ECR registry with this command: aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 222634386594.dkr.ecr.eu-north-1.amazonaws.com
- Tagging the images: docker tag rsschool-devops-course-tasks-server:latest 222634386594.dkr.ecr.eu-north-1.amazonaws.com/emrah-server:v1
- Pushing the images: docker push 222634386594.dkr.ecr.eu-north-1.amazonaws.com/emrah-server:v1
- Ensure your K8s nodes can access the ECR repository by adjusting or creating a new instance profile for your EC2 instances: Previous steps was for local to ECR access. I also created IAM Role for K3s (running on ec2) to ECR access.  
![alt text](ecr_access_role.png)
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
![alt text](<Test the Helm chart manually from your local machine..png>)

### 3.Store Artifacts in Git
-Store the Dockerfile and Helm chart in a git repository accessible to Jenkins: All files are stored on Github repository and I created credentials in Jenkins to access it.
![alt text](<Store the Dockerfile and Helm chart in a git repository accessible to Jenkins.png>)

### 4.Configure Jenkins Pipeline

- Create a Jenkins pipeline and store it as a Jenkinsfile in your main git repository: The jenkinsfile is under the root folder.
- Configure the pipeline to be triggered on each push event to the repository: I created a webhook as below. When I push the repository, it is triggering the Jenkins pipeline.
![alt text](<Configure the pipeline to be triggered on each push event to the repository.png>)






