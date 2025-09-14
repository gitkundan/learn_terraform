#!/bin/bash

echo "Applying prod networking configuration..."
cd networking
terraform init && terraform apply -auto-approve
cd ..