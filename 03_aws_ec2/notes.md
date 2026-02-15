# how to keep the bootstrap script
while the bootstrap script can be kept inside main.tf as heredoc syntax a better option is to

# How to locate AMI ID
To filter for Ubuntu Amazon Machine Images (AMIs) using the AWS Command Line Interface (CLI), you can use the `aws ec2 describe-images` command with specific filters for the owner and the image name. It is a crucial security best practice to specify the owner to ensure you are using an official image from Canonical, the company behind Ubuntu.[1][2]

### Finding the Latest Ubuntu AMI

A common task is to find the most recent version of a specific Ubuntu release. The following command finds the latest AMI for Ubuntu 22.04 (Jammy Jellyfish) and returns only its AMI ID.[2]

```bash
aws ec2 describe-images \
    --owners 099720109477 \
    --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" \
    --query "sort_by(Images, &CreationDate) | [-1].ImageId" \
    --output text
```

#### Command Breakdown
*   `--owners 099720109477`: This filters the results to show only AMIs published by Canonical's official account ID, which is `099720109477`. This prevents you from accidentally using a malicious or unofficial image.[2]
*   `--filters "Name=name,Values=...*"`: This filter searches for AMIs where the `name` field matches a specific pattern. Ubuntu AMIs follow a predictable naming convention. The asterisk `*` acts as a wildcard to match the latest build number.[2]
*   `--query "sort_by(Images, &CreationDate) | [-1].ImageId"`: This uses the built-in JMESPath query language to process the JSON output.
    *   `sort_by(Images, &CreationDate)` sorts all matching images by their creation date in ascending order.[3][2]
    *   `| [-1]` selects the last item from the sorted list, which is the most recent image [2].
    *   `.ImageId` extracts the value of the `ImageId` field from the final result.[2]
*   `--output text`: This formats the output as plain text, making it easy to use in scripts.[2]
---
# SSH key access
either provide reference to an existing ssh key or create a new ssh key via terraform
You can securely provide SSH keys to an EC2 instance using Terraform without relying on `remote-exec` provisioners. The standard and recommended approach is to use the `aws_key_pair` resource in conjunction with an `aws_instance`.[1]

This method involves providing the public key to AWS, which then installs it on the EC2 instance at launch time. This allows you to SSH into the instance using the corresponding private key.

There are two primary ways to manage the key pair itself:

1.  **Using an Existing Key Pair:** If you already have an SSH key pair that you want to use, you can create an `aws_key_pair` resource and provide the content of your public key.[1]
2.  **Generating a New Key Pair:** Terraform can also generate a new SSH key pair for you using the `tls_private_key` resource from the `tls` provider.[2]

### Using an Existing SSH Key Pair

This is the most straightforward method if you have a pre-existing key pair you want to reuse.

1.  **Create an `aws_key_pair` resource**: In your Terraform configuration, define an `aws_key_pair` resource. The `public_key` argument should be set to the content of your public key file (e.g., `~/.ssh/id_rsa.pub`).[1]
2.  **Reference the key pair in your `aws_instance`**: In your `aws_instance` resource, set the `key_name` argument to the name of the `aws_key_pair` you created.[1]

Here is an example:

```terraform
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Example AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name

  tags = {
    Name = "HelloWorld"
  }
}
```

With this configuration, when you run `terraform apply`, Terraform will upload your public key to AWS with the name `deployer-key`. Then, when the EC2 instance is created, AWS will automatically install this public key, allowing you to SSH into the instance using your private key.

### Generating a New SSH Key Pair with Terraform

If you need to programmatically generate unique keys for different environments or users, you can use the `tls` provider.[2]

1.  **Generate a private key**: Use the `tls_private_key` resource to create a new RSA private key.[2]
2.  **Create an `aws_key_pair`**: Use the public key from the `tls_private_key` resource to create an `aws_key_pair`.[2]
3.  **Reference the key pair**: In your `aws_instance` resource, reference the `key_name` of the generated key pair.[2]
4.  **Output the private key**: Use a Terraform `output` to display the generated private key. **Note:** Treat this private key as sensitive information.[2]

Here is an example:

```terraform
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "generated-key"
  public_key = tls_private_key.example.public_key_openssh
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Example AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name

  tags = {
    Name = "HelloWorld"
  }
}

output "private_key" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}
```

After applying this configuration, you can retrieve the generated private key from the Terraform output using `terraform output -raw private_key` and save it to a file. You can then use this key to SSH into your instance.
```terraform output -raw private_key > private_key.pem && chmod 400 private_key.pem```

ssh into machine :
```ssh -i ./private_key.pem ubuntu@$(terraform output -raw public_ip)```



---
