# Configure provider
provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create subnets
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
}

# Create Fargate task definition
resource "aws_ecs_task_definition" "task_definition" {
  family                   = "BatchJobTaskDefinition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512

  container_definitions = <<EOF
[
  {
    "name": "batch-job-container",
    "image": "your-ecr-repo/image:tag",
    "portMappings": [
      {
        "containerPort": 80,
        "protocol": "tcp"
      }
    ]
  }
]
EOF
}

# Create S3 bucket
resource "aws_s3_bucket" "input_bucket" {
  bucket = "batch-job-input"
}

resource "aws_s3_bucket" "output_bucket" {
  bucket = "batch-job-output"
}

# Create CloudWatch Events rule
resource "aws_cloudwatch_event_rule" "event_rule" {
  name        = "BatchJobEventRule"
  description = "Event rule to trigger Fargate task"

  event_pattern = <<EOF
{
  "source": [
    "aws.s3"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "s3.amazonaws.com"
    ],
    "eventName": [
      "PutObject",
      "CompleteMultipartUpload"
    ],
    "requestParameters": {
      "bucketName": [
        "${aws_s3_bucket.input_bucket.id}"
      ]
    }
  }
}
EOF
}

# Create ECR repository
resource "aws_ecr_repository" "repository" {
  name = "batch-job-repo"
}

# Create IAM role for Fargate task
resource "aws_iam_role" "task_role" {
  name = "BatchJobTaskRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach policies to IAM role
resource "aws_iam_role_policy_attachment" "task_role_attachment" {
  role       = aws_iam_role.task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
