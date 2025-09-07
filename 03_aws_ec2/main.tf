# Create a new private key
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an AWS key pair from the generated private key
resource "aws_key_pair" "generated_key" {
  key_name   = "generated-key"
  public_key = tls_private_key.example.public_key_openssh
}

# Define a security group to allow SSH and HTTP access
resource "aws_security_group" "web-access" {
  name        = "web-access"
  description = "Allow SSH and HTTP access"

  # Allow inbound SSH traffic from anywhere (for demonstration and not suitable for production, where you need to restrict to own IP)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access"
  }

  # Allow inbound HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access for Nginx"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the EC2 instance
resource "aws_instance" "webserver" {
  ami           = "ami-0bbdd8c17ed981ef9" # Ubuntu AMI in us-east-1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.web-access.id]

  tags = {
    Name        = "webserver"
    Description = "An nginx webserver on Ubuntu"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF
}

# Output the generated private key (handle with care)
output "private_key" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}

# Output the public IP and DNS of the webserver
output "public_ip" {
  value = aws_instance.webserver.public_ip
}

output "public_dns" {
  value = aws_instance.webserver.public_dns
}