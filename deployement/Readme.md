# CI/CD Pipeline Deployment

     steps to deploy the CI/CD pipeline using the provided CloudFormation template.

## Prerequisites : #

* An AWS account with the necessary permissions to create AWS resources.
* GitHub repository with the source code to be deployed.
* Docker image repository in Amazon ECR for storing the Docker images.
* ECS Fargate task definition for defining the deployment configuration.

## Deployment Steps : #

1 . Clone the GitHub repository that contains the CloudFormation template and navigate to the project directory.

      git clone <repository_url>
      cd <repository_directory>

2 . Open the pipeline.yaml file and customize the parameters according to your environment:

* GitHubOwner: Provide the GitHub username or organization name.
* GitHubRepo: Provide the name of the GitHub repository.
* GitHubBranch: Specify the branch to be used for deployment.
* GitHubToken: Set the GitHub personal access token with appropriate repository access.
* ECRRepository: Provide the name of the ECR repository to store Docker images.
* ECSFargateTaskDefinition: Specify the ARN of the ECS Fargate task definition.

3 . Deploy the CloudFormation stack using the AWS CLI:

    aws cloudformation create-stack --stack-name my-cicd-pipeline --template-body file://pipeline.yaml --capabilities CAPABILITY_IAM
Wait for the stack creation to complete. This may take a few minute .

4 . Once the stack creation is complete, the CI/CD pipeline is ready. You can now navigate to the AWS CodePipeline console and view the pipeline.

5 . Make changes to your source code in the GitHub repository. Commit and push the changes to the specified branch.

6 . The pipeline will automatically trigger the build and deployment stages. Once the deployment stage is reached, manual approval is required.

7 . Open the AWS CodePipeline console, navigate to the pipeline, and review the changes to be deployed.

8 . If the changes are approved, click the "Approve" button in the pipeline. The deployment will proceed.

9 . Monitor the pipeline execution and verify the successful deployment of the updated application.



