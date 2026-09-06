```Yaml

name: Terraform Drift Detection

on:
  schedule:
    - cron: '0 8 * * 1-5' # Runs every weekday at 8:00 AM UTC
  workflow_dispatch: # Allows manual trigger from GitHub UI

jobs:
  detect-drift:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.5.0

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Terraform Init
        run: terraform init

      - name: Terraform Plan (Check Drift)
        id: tf-plan
        continue-on-error: true
        run: |
          terraform plan -detailed-exitcode -no-color

#terraform plan -detailed-exitcode: Changes how Terraform reports its findings via exit codes:
#0 = Succeeded, with no changes (infrastructure matches code).
#1 = Errored / Failed due to a syntax or provider error.
#2 = Succeeded, but there are changes/drift detected between your code and the actual cloud environment.

      - name: Notify on Drift
        if: steps.tf-plan.outputs.exitcode == 2
        uses: 8398a7/action-slack@v3
        with:
          status: custom
          fields: repo,message
          custom_payload: |
            {
              "text": "🚨 *Terraform Drift Detected!* Infrastructure has been modified outside of Terraform in repository ${{ github.repository }}.",
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }} # Optional: use your team's notification webhook

```

## How to Resolve the Drift Once Identified
Once identified via the plan output, you have two choices depending on your intent:

# Resolve the Drift: 
Remediation.Apply the appropriate fix based on your decision from Step 2:To discard the change: Run terraform apply. Terraform will recognize that the live resource differs from the code and will automatically overwrite the manual changes to match your configuration.

# To keep the change: 
Update your .tf configuration files to reflect the manual updates, then run terraform apply to sync the state file without altering the resource.
