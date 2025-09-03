# Learning Terraform Repo

This repository is for learning Terraform.

## Structure

Each folder in this repository is a separate learning exercise and is independent of the others.

## Pre-requisites

- Download and install AWS CLI and Terraform CLI.
- Use an AWS account or  [provision a sandbox from O'Reilly](https://learning.oreilly.com/interactive-lab/aws-sandbox/9781098146603/lab/).
- Run `aws configure` to set up your AWS credentials.
- Run `aws sts get-caller-identity` to do a whoami check on your AWS identity.
- in bash terminal `alias tf=terraform`
- `export TF_CLI_ARGS_apply="-auto-approve"`

## Terraform CLI Cheatsheet

### Core Workflow Commands
*   `terraform init`
    *   Initializes your working directory. It downloads provider plugins, configures the backend, and installs any child modules. This is the first command you run in a new Terraform project.
*   `terraform plan`
    *   Creates an execution plan, showing you what actions Terraform will take to modify your infrastructure. It's a dry run that lets you review changes before applying them.
*   `terraform apply`
    *   Applies the changes described in your Terraform configuration to create, update, or delete resources. It will show the plan and prompt for confirmation before proceeding.
*   `terraform destroy`
    *   Destroys all the resources managed by your Terraform configuration. It also prompts for confirmation before deleting anything.

### State Management
*   `terraform state list`
    *   Lists all the resources that are currently tracked in your Terraform state file.
*   `terraform state show <resource_address>`
    *   Shows the detailed attributes of a specific resource in the state file.
    *   Example: `terraform state show aws_s3_bucket.my_bucket`
*   `terraform import <resource_address> <resource_id>`
    *   Brings an existing, manually-created resource under Terraform's management by adding it to the state file.
    *   Example: `terraform import aws_s3_bucket.my_bucket my-existing-bucket-name`
*   `terraform state rm <resource_address>`
    *   Removes a resource from the Terraform state file. This does **not** destroy the resource in the real world; it only makes Terraform "forget" about it.

### Inspection and Formatting
*   `terraform output`
    *   Displays the values of the output variables from your configuration.
*   `terraform fmt`
    *   Automatically formats your `.tf` files to the canonical Terraform style for readability and consistency.
*   `terraform validate`
    *   Checks your configuration files for syntax errors and internal consistency without accessing remote services or state.

### Workspaces
*   `terraform workspace list`
    *   Lists all existing workspaces.
*   `terraform workspace new <name>`
    *   Creates a new workspace. Workspaces allow you to manage multiple distinct states for the same configuration (e.g., for `dev`, `staging`, and `prod` environments).
*   `terraform workspace select <name>`
    *   Switches to a different workspace.

### Helpful Flags
*   `-auto-approve`
    *   Skips the interactive confirmation prompt for `apply` and `destroy`. Useful for automation.
    *   Example: `terraform apply -auto-approve`
*   `-refresh=false`
    *   Disables the default behavior of refreshing the state before running a plan or apply. Use with caution, as it can lead to state drift.
*   `-target=<resource_address>`
    *   Targets a specific resource for an operation. This is useful for troubleshooting but should be avoided in normal workflows.
    *   Example: `terraform apply -target=aws_instance.my_vm`