When two engineers run `terraform apply` simultaneously without proper state locking, it can result in a corrupted or conflicting state file. You can recover your infrastructure state using the following steps:

## 1. **Restore from S3 Object Versioning:** 
Option A: Remote Backend.
If your state is stored in an AWS S3 bucket, **Object Versioning** is your primary safety net.

1. Open the **S3 Console** and navigate to your Terraform state bucket.
2. Click on your `terraform.tfstate` file and go to the **Versions** tab.
3. Locate the version of the state file created *just before* the corrupted concurrent apply.
4. Download that version, rename/restore it to overwrite the current corrupted state file in S3.


## 2. **Use the Automatic Backup File:**
   Option B: Local Backend.
If you are running Terraform locally, Terraform automatically writes a backup before modifying the state.

1. Locate your project directory containing `terraform.tfstate`.
2. Move the corrupted `terraform.tfstate` to a safe backup location for reference.
3. Rename the backup file (`terraform.tfstate.backup`) to `terraform.tfstate`.


 ## 3. **Run Terraform Plan:**
   Validation.
Run `terraform plan` to check if Terraform can successfully read the restored state and map it against your live infrastructure.


 ## 4. **Enable State Locking:**
 Root Cause Prevention.
Prevent this from happening again by ensuring state locking is strictly enforced so concurrent runs are blocked automatically:

* If using an S3 backend, enable native locking by adding `use_lockfile = true` in your backend block.
