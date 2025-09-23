# Terraform Notes

## Key Concepts

- **Provider**: Like a plugin that connects Terraform to a specific cloud or service (e.g., AWS, Google, Azure, MySQL, CloudFlare). You need a provider for every service you want to control.

- **Resource**: Anything you want to create or manage (like a server, database, file, or S3 bucket). Every resource uses a provider.

- **State File (`.tfstate`)**: Keeps track of everything Terraform creates. It’s used to compare what’s in your code versus what actually exists. Tracks metadata, how resources are dependent, performance, collaboration.

- **Module**: A folder with multiple `.tf` files working together as a reusable unit. Even a single file in a directory is called the “root module.”

## How Does Terraform Work?

- **Three Phases**
  1. **init**: Prepares configuration, downloads plugins, sets up folders.
  2. **plan**: Shows the difference between current and desired state; a dry run of changes.
  3. **apply**: Actually makes the changes and updates the infrastructure.

- **Configuration Files**
  - Files end with `.tf`
  - Common files:
    - `main.tf`: Main resource definitions.
    - `variables.tf`: Variable definitions.
    - `outputs.tf`: Declares outputs.
    - `provider.tf`: Details about provider (e.g., AWS).

- **Example Resource**
  ```hcl
  resource "local_file" "pet" {
      filename = "/root/pets.txt"
      content  = "WE love pets!"
  }
  ```

## Terraform Language

- **Blocks**: Main structure, e.g., `resource`, `module`, `provider`.
- **Arguments**: Settings inside blocks (e.g., `filename`, `content`).
- **Expressions**: Values or references (e.g., `"WE love pets!"`, or `var.filename`).

## Working With Terraform

- **Immutable by Default**: Instead of changing a file, Terraform will destroy and recreate it.
- **Common Commands**
  - `validate`: Syntax checker.
  - `fmt`: Formats code.
  - `show`: Displays resources and attributes.
  - `providers`: Lists all providers.
  - `output`: Shows outputs defined.
  - `refresh`: Updates state file to match the real world.
  - `graph`: Shows how resources depend on each other.

## Variables & Outputs

- **Variables**: Defined in `variables.tf`, used as placeholders for values; referred to as `var.variable_name` in other files.
- **Types**: `string`, `bool`, `number`, `list`, `map`, `object`, etc.
- **Output Block**: Shows or passes values that Terraform creates, e.g.:
  ```hcl
  output "pet-name" {
      value       = random_pet.my-pet.id
      description = "Record the value of pet ID generated"
  }
  ```

## Dependency Management

- **Implicit**: Terraform figures out order from references.
- **Explicit**: Use `depends_on` to set an order.

## Remote State

- **Centralized State**: Multiple developers should use a shared remote state, not local files.
- **Never store `.tfstate` in Git/VCS**: Contains secrets.
- to prevent concurrent operation on tfstate file tf does state locking.

## Lifecycle Rules

- **By default**: Destroy old, then create new.
- Use lifecycle block to change:
  - `create_before_destroy`: Create new first, then destroy old.
  - `prevent_destroy = true`: Prevents accidental deletions.
  - `ignore_changes`: Ignored attributes if changed outside Terraform.

## Data Block

- Like a resource, but used for reading existing data (local files, configs, etc.) to use elsewhere in Terraform.

## Count and For_each

- **count**: Easily create multiple copies of a resource (`count=3` creates three).
- **for_each**: Iterates over a set or map for creating resources.

## Debugging

- Use output blocks to check or debug variables, loops, etc.

## Naming

- **Resource Type**: Follows `provider_resource_type` (e.g., `aws_instance`, `google_storage_bucket`).
- **Local Name**: Unique name you pick for each resource (`aws_instance.web_server`). Lets you have more than one of the same type.

## Miscellaneous
- Terraform has no version for resources; only for providers.
- **Plan without refresh**: `terraform plan --refresh=false` uses only local state file.
- Running `terraform plan --refresh=false` is used to create an execution plan based only on the local state file, without checking the real infrastructure.
- This makes it faster, as no API calls are made to the cloud provider.
- It is useful in large or production environments where checking every resource would be time-consuming.
- It ensures plans are based on the expected state as stored in Terraform, not any changes made outside it.
- Use this when you trust your state file and want to avoid unnecessary remote checks, but be aware that undetected changes outside Terraform could be missed.

## Terraform Import CLI
The `terraform import` CLI command allows you to bring existing, manually-created infrastructure under Terraform's management. It does this by reading the current state of a resource from your cloud provider and writing it into your Terraform state file. This enables you to manage and update the resource using your Terraform configuration from that point forward.

It's important to note that terraform import does not automatically generate the corresponding configuration code for the resource. You must write the resource block in your .tf files yourself before you can import the object into the state.

This is a CLI command and not the same as importing modules in terraform configuration

## Terraform Module
A module is a folder which has multiple terraform configuration files
# TODO
deeper dive on tf modules
https://developer.hashicorp.com/terraform/tutorials/modules
https://www.gruntwork.io/blog/how-to-create-reusable-infrastructure-with-terraform-modules
https://devopscube.com/terraform-module-best-practices/

## Terraform state
To understand current inventory tracked in state (this is ls) `tf state list`
To see all resources (in detail) `tf show`
To see details of particular resource `tf state show aws_key_pair.deployer`
To replace only one resource rather than destroying everything and re-building everything : `tf apply -replace=aws_key_pair.deployer`. use case of this : OS patching, IP address changes as the same resource is destroyed and then re-built from ground up. This is the modern replacement of taint command
To see dry run of destrory : `tf plan -destroy`
change value of one variable in resource `tf apply -var "var_name=var_value"`. You cannot create new variable through this only change value of existing variable

# Variable Precedence
Here is the corrected precedence order for Terraform variables, from highest to lowest. Terraform loads variables from multiple sources and merges them, with later sources overriding values from earlier ones.

*   **Command-line flags:** Values provided via the `-var` and `-var-file` options on the command line have the highest precedence and will override all other values.
*   **`*.auto.tfvars` and `*.auto.tfvars.json`:** Any files ending with these suffixes are loaded automatically. They are processed in alphabetical order of their filenames.
*   **`terraform.tfvars.json`:** If this file is present, its contents are loaded automatically. It will override values set in `terraform.tfvars`.
*   **`terraform.tfvars`:** This file is also automatically loaded if it exists.
*   **Environment variables:** Terraform reads environment variables prefixed with `TF_VAR_` (e.g., `TF_VAR_region="us-east-1"`).
*   **Variable Defaults:** The `default` argument within a `variable` block in your `.tf` files has the lowest precedence.