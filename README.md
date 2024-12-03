# JAJAF

## Description

This project will allow you to deploy a CloudFront distribution with IP filtering at a lower cost (without using AWS WAF). Two solutions are proposed here:

- **With Lambda@Edge**: More flexible, with whitelisted IPs stored in a Parameter Store.
- **With CloudFront Function**: Less expensive than Lambda@Edge, but offers less flexibility as the IPs are stored in the code. Thus, the function must be redeployed whenever an IP is added or removed.

## Module CloudFront Function

### Declaration and Deployment

⚠️ Before you begin, check your `provider.tf` file to ensure that you can store your `tfstate` correctly. It is also important to note that the `us-east-1` region must be used (since CloudFront is a global service). The deployment and deletion of this infrastructure may take some time depending on the CloudFront deployment (usually around fifteen minutes).

```terraform
module "jajaf_cloudfront_function" {
  source       = "./modules/jajaf_cloudfront_function"
  project_name = "myproject"
  ip_whitelist = [
    "12.12.12.12",
    "13.13.13.13"
  ]
}
```

### Some explanations:

- `project_name`: Name for your project.
- `ip_whitelist`: List of all authorized IPs.

You can now deploy the infrastructure with Terraform.

```bash
terraform init
terraform plan
terraform apply
```

## Module Lambda@Edge

### Declaration and Deployment

⚠️ Before you begin, check your `provider.tf` file to ensure that you can store your `tfstate` correctly. It is also important to note that the `us-east-1` region must be used (since CloudFront is a global service). The deployment and deletion of this infrastructure may take some time depending on the CloudFront deployment (usually around fifteen minutes). Finally, the deletion of the Lambda@Edge may take some time, and Terraform may generate an error. Simply wait for a while and try again (it may take several hours depending on CloudFront propagation).

```terraform
module "jajaf_lambda_edge" {
  source       = "./modules/jajaf_lambda_edge"
  project_name = "myproject"
  ip_whitelist = [
    "12.12.12.12",
    "13.13.13.13"
  ]
}
```

### Some explanations:

- `project_name`: Name for your project.
- `ip_whitelist`: List of all authorized IPs.

You can now deploy the infrastructure with Terraform.

```bash
terraform init
terraform plan
terraform apply
```