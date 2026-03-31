# Security Checks Workflow

This repository includes a comprehensive security checks workflow that automatically scans the Terraform infrastructure code for security issues and best practices.

## Features

The security workflow includes the following checks:

### 1. **Terraform Security Scan Job**
- **Terraform Format Check**: Ensures all Terraform files follow proper formatting standards
- **Terraform Validation**: Validates the Terraform configuration syntax and structure
- **TFLint**: Lints Terraform code for potential issues and best practices
- **Checkov**: Scans Infrastructure as Code for security misconfigurations
- **TFSec**: Identifies security issues in Terraform code

### 2. **Dependency Security Check Job**
- **Trivy**: Scans for vulnerabilities in configuration files and dependencies
- Results are uploaded to GitHub Security tab (SARIF format)

### 3. **Secret Scanning Job**
- **TruffleHog**: Scans for accidentally committed secrets, API keys, and credentials
- Alerts on pull requests if secrets are detected

## How It Works

### Automatic Triggers
The workflow runs automatically on:
- Pull requests to `main` or `master` branches
- Pushes to `main` or `master` branches
- Manual trigger via `workflow_dispatch`

### PR Comments
When running on pull requests, the workflow will:
- Post a detailed comment with security scan results
- Update the comment if the workflow runs again
- Provide actionable feedback with ✅, ⚠️, and ❌ indicators
- Link to detailed artifacts for comprehensive reports

### Security Results Format

The PR comment includes:
- **Terraform Format Check**: Status of code formatting
- **Terraform Validation**: Configuration validation status
- **TFLint Analysis**: Linting issues and recommendations
- **Checkov Security Scan**: Infrastructure security findings
- **TFSec Security Scan**: Terraform-specific security issues

### Artifacts
Detailed reports are saved as workflow artifacts:
- `checkov-results`: Checkov security scan results
- `tfsec-results`: TFSec security findings
- `tflint-results`: TFLint analysis output

## Fixing Issues

### Terraform Formatting
```bash
terraform fmt -recursive
```

### Terraform Validation
```bash
terraform init
terraform validate
```

### Running Checks Locally

#### TFLint
```bash
# Install TFLint
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Run TFLint
tflint --init
tflint --recursive
```

#### Checkov
```bash
# Install Checkov
pip install checkov

# Run Checkov
checkov -d . --framework terraform
```

#### TFSec
```bash
# Install TFSec
brew install tfsec  # macOS
# or
curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash

# Run TFSec
tfsec .
```

## Required Permissions

The workflow requires the following permissions:
- `contents: read` - To checkout code
- `pull-requests: write` - To comment on PRs
- `issues: write` - To create issue comments
- `security-events: write` - To upload SARIF results to Security tab

## Best Practices

1. **Address all ❌ failures** before merging
2. **Review ⚠️ warnings** and fix when appropriate
3. **Check artifacts** for detailed security reports
4. **Never commit secrets** - use environment variables or secret management tools
5. **Keep Terraform modules updated** to include latest security patches

## Troubleshooting

### Workflow fails on format check
Run `terraform fmt -recursive` locally and commit the changes.

### Validation fails
Ensure your Terraform configuration is valid by running `terraform validate` locally.

### Security issues detected
Review the specific security findings in the PR comment and artifacts. Address critical and high-severity issues before merging.

### Secret scanning alerts
If secrets are detected:
1. Remove the secrets from your code
2. Rotate any exposed credentials immediately
3. Use GitHub Secrets or a secret management service
4. Add sensitive patterns to `.gitignore`

## Support

For issues or questions about the security workflow, please open an issue in the repository.
