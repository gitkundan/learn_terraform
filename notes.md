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