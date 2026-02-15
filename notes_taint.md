**Terraform taint** is a command that marks a specific resource in the Terraform state as needing replacement, meaning it will be destroyed and recreated during the next `terraform apply` run, even if its configuration hasn't changed. **Terraform untaint** is the opposite: it removes the tainted status from a resource, so Terraform will no longer try to replace it in the next apply.[1][2][4][5][7]

## How Terraform Taint Works

- The `terraform taint <resource_name>` command flags a resource as "tainted" in the state file, not the actual infrastructure.[6][1]
- The next time `terraform apply` is run, Terraform will destroy and recreate the tainted resource, following its current configuration.[2][4]
- This is useful for resources that become misconfigured, degraded, or need a forced update due to issues outside Terraform's knowledge.[3][5]

## How Terraform Untaint Works

- The `terraform untaint <resource_name>` command reverses the taint, so the resource is not replaced during the next apply.[5][7]
- This is helpful if a resource was mistakenly marked for replacement or the issue was resolved, and recreation is no longer required.[7]

## Important Notes

- As of Terraform v0.15.2 and later, the taint/untaint commands are deprecated. The recommended approach is to use the `terraform apply -replace="resource.name"` option instead, which achieves the same effect but with an explicit plan.[1][2]
- Tainting only affects the resource at the next apply, not the immediate infrastructure or configuration files.[6][1]

In summary, **terraform taint** and **untaint** allow manual control over resource recreation for troubleshooting or recovery, but the modern preferred workflow is now the `-replace` flag during apply.[2][1]

[1](https://developer.hashicorp.com/terraform/cli/commands/taint)
[2](https://spacelift.io/blog/terraform-taint)
[3](https://www.purestorage.com/knowledge/what-is-terraform-taint.html)
[4](https://terrateam.io/blog/terraform-taint)
[5](https://scalr.com/glossary/terraform-taint)
[6](https://learning-ocean.com/tutorials/terraform/terraform-taint/)
[7](https://notes.kodekloud.com/docs/Terraform-Basics-Training-Course/Terraform-Import-Tainting-Resources-and-Debugging/Terraform-Taint)
[8](https://www.youtube.com/watch?v=v_T1fuYGjV0)
[9](https://nedinthecloud.com/2024/01/16/terraform-taint-is-bad-and-heres-why/)