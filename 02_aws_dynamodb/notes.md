## Notes
- use `aws dyanmodb list-tables` to see all tables that are created

## Use of `aws_dynamodb_table_item`
while terraform providers `aws_dynamodb_table_item` use is sparingly.

While you *can* create a DynamoDB item with Terraform, you should almost **never** use it for regular application data. That resource is designed for a very specific and limited purpose.

### The Purpose of `aws_dynamodb_table_item`

The `aws_dynamodb_table_item` resource is intended for managing **static seed data** or **configuration data**. This is data that is tightly coupled to the infrastructure itself and rarely, if ever, changes.

Think of it as part of the initial state of the system.

**Good Use Cases:**

*   **Configuration Entry:** Creating a single item that holds default settings for an application, which the app reads on startup.
*   **Initial Admin User:** Creating the very first administrator user account during a system's initial deployment.
*   **Singleton Resources:** A single, well-known entry that acts as a feature flag or a system-wide counter.

In these cases, the data is essentially part of the infrastructure's definition.

### Why It's an Anti-Pattern for Application Data

Using `aws_dynamodb_table_item` to manage dynamic data that your application creates, reads, updates, and deletes (like user profiles, product catalogs, sensor readings, etc.) is a major anti-pattern for several critical reasons:

1.  **Terraform State Bloat and Performance Collapse:** Terraform must track every single resource it manages in its state file. If you define thousands or millions of DynamoDB items in Terraform, your state file will become enormous. Every `terraform plan` and `apply` will become painfully slow, as Terraform attempts to reconcile the state of every single item. It simply does not scale.

2.  **Declarative Model vs. Dynamic Data:** Terraform is declarative—it enforces a desired state. Application data is dynamic and changes constantly at runtime. If a user updates their profile through your app, that change will be "drift" from Terraform's perspective. The next time you run `terraform apply`, it will try to revert that change back to what's defined in your code, potentially causing data loss.

3.  **Mixing Infrastructure and Application Logic:** Your infrastructure code (Terraform) should not be concerned with the data inside your database. That is the job of your application. Mixing them makes your system incredibly brittle and hard to manage. A simple data change would require an infrastructure deployment.

### The Correct Model: A Clear Rule of Thumb

Here is the definitive best practice:

| Resource Type | Managed By | Reason |
| :--- | :--- | :--- |
| **The Table itself** (`aws_dynamodb_table`) | **Terraform** | This is infrastructure. It's a static resource whose schema changes infrequently. |
| **A few seed/config items** (`aws_dynamodb_table_item`) | **Terraform** | This is initial state or configuration required for the infrastructure to function. Treat it as a rare exception. |
| **All other items** (Application Data) | **Python SDK (Boto3)** | This is dynamic data. It's managed at runtime by your application, completely outside of Terraform's control. |
