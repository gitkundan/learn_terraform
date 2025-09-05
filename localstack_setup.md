# Note : this instruction is not complete, this instruction is for docker setup in winwods and running localstack cli in wsl2 ubuntu
# Docker Setup
## Update packages
sudo apt update && sudo apt upgrade -y

# Docker setup
sudo apt install docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
newgrp docker  # Refresh group permissions

# Run LocalStack
docker run -d --name localstack \
  -p 4566:4566 -p 4510-4559:4510-4559 \
  -e SERVICES=s3,dynamodb,secretsmanager \
  localstack/localstack

# Configure AWS API
## Configure ~/.aws/credentials:
[default]
aws_access_key_id = test
aws_secret_access_key = test

## Configure ~/.aws/config:
[default]
region = us-east-1
output = json

## Test configuration
aws --endpoint-url=http://localhost:4566 sts get-caller-identity

export AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_ENDPOINT_URL=http://localhost:4566 && terraform init && terraform apply -auto-approve