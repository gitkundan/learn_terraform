## Overview / Intro
**Terraform provisioners let you run imperative actions (scripts, file copies, commands) on local or remote machines during a resource lifecycle.** They’re useful for bootstrapping or one-off tasks but introduce imperative complexity into Terraform’s declarative model, so HashiCorp recommends using them only as a last resort.

---

## 1. What Are Terraform Provisioners?
- Purpose: execute scripts/actions on a machine as part of resource creation or destruction.
- Common uses: instance bootstrapping, triggering config-management, seeding data, cleanup before destroy.
- Tradeoff: add imperative logic, can reduce predictability and manageability of Terraform configs.

---

## 2. When to Consider Provisioners (and When Not To)
- Appropriate scenarios:
  - Initial bootstrapping not feasible via other means.
  - Triggering configuration management (Ansible, Chef, Puppet).
  - One-off data seeding or application initialization on the resource.
  - Cleanup actions before resource destruction.
- Prefer alternatives first:
  - user_data/cloud-init
  - Pre-baked images (AMI/VHD)
  - Native Terraform provider resources or features
- Rule of thumb: if alternatives suffice, avoid provisioners.

---

## 3. Declaring the Core Provisioners
- Syntax: placed inside a resource block as provisioner "<type>" { ... }.
- Most common types: file, local-exec, remote-exec.

### 3.1 The file Provisioner
- Function: copy local files/directories to the remote resource.
- Key arguments: source (local path) or content (literal), destination (remote path).
- Connection block required (SSH/RDP) with host, user, auth.
- Caution: remote user must have write permissions.

### 3.2 The local-exec Provisioner
- Function: run a command/script on the machine executing terraform (local machine).
- Key arguments: command, working_dir, interpreter, environment.
- Use cases: write outputs to local files, trigger local tooling.
- Security note: avoid interpolating untrusted inputs directly into command; prefer environment vars.

### 3.3 The remote-exec Provisioner
- Function: run commands on the remote target via an established connection.
- Typical use: run bootstrapping or configuration commands after resource is reachable.
- Requires connection configuration (SSH for Linux, WinRM for Windows).
- Key arguments: inline (list of commands) or script (path to local script to upload and run).

---

## 4. Connections: How Provisioners Reach Targets
- Connection block types: ssh (Linux), winrm (Windows), others supported by providers.
- Common fields: host, user, private_key, password, timeout.
- Best practices: use reliable host addresses (e.g., public_ip or private_ip when appropriate), ensure correct auth and permissions.

---

## 5. Provisioner Lifecycle and Behavior
- Execution timing: provisioners run during create or destroy phases attached to resources.
- Error handling: failures can stop terraform apply/destroy; provisioners support retry and timeout settings.
- Dependence on resource state: provisioners use the resource’s addresses (self.*) and assume resource is reachable.

---

## 6. Best Practices and Recommendations
- Prefer declarative alternatives (user_data, baked images, provider resources) before using provisioners.
- Keep provisioner use minimal and isolated — only for tasks that cannot be done otherwise.
- Use provisioners to trigger external configuration management rather than encode complex logic in them.
- Use retries/timeouts to make provisioners more resilient.
- Avoid sensitive data in commands; use environment variables or secure secret mechanisms.
- Test provisioners independently and ensure idempotence where possible.

---

## 7. Common Pitfalls and Gotchas
- Imperative actions break declarative guarantees — can lead to drift and unpredictable applies.
- Network/availability race: provisioner may run before resource is fully reachable.
- Hard-to-debug failures during apply/destroy; failed provisioners can leave partial resources.
- Mixing local execution with remote assumptions (e.g., paths, permissions) causes platform-specific failures.
- Insecure handling of secrets (interpolating them directly) risks exposure.

---

## 8. When to Use Provisioners vs. Alternatives (Summary Guidance)
- Use alternatives first: cloud-init/user_data, provider-native resources, pre-baked images, config management.
- Use provisioners when:
  - No other mechanism can perform the task reliably.
  - You need a short, controlled bootstrap step or a one-off action.
  - You’re triggering an external tool that will take over configuration management.
- Keep provisioner usage scoped, simple, and well-documented.

---

## Example Snippets (conceptual)
- file: copy config from local to /etc on remote (requires connection block).
- local-exec: write resource IP to a local file after creation.
- remote-exec: run bootstrap commands on a newly provisioned instance via SSH.

---

## Conclusion
**Provisioners are a pragmatic escape hatch for imperative needs in Terraform, but they should be used sparingly and only after considering declarative alternatives.** When used, apply best practices: reliable connections, minimal scope, secure handling of data, retries/timeouts, and clear documentation.
---

Source :
1. https://scalr.com/learning-center/understanding-terraform-provisioners-the-sword-of-infrastructure-automation/
2. https://spacelift.io/blog/terraform-provisioners