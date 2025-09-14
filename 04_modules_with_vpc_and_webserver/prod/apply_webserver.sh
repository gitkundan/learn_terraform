#!/bin/bash

echo "Applying prod webserver configuration..."
cd webserver
terraform init && terraform apply -auto-approve
cd ..