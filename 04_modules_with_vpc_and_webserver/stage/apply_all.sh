#!/bin/bash

echo "Applying full stage configuration..."
terraform init && terraform apply -auto-approve