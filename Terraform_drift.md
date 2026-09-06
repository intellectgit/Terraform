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
