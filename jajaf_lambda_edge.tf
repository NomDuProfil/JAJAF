/*

# Author information

Name: NomDuProfil
Website: valou.io

# Module information

This module creates a CloudFront distribution with IP filtering implemented using Lambda@Edge.

# Variables

| Name         | Type         | Description                                                   |
|--------------|--------------|---------------------------------------------------------------|
| project_name | string       | Name for the project                                          |
| ip_whitelist | list(string) | IP to whitelist                                               |

# Example

module "jajaf_lambda_edge" {
  source       = "./modules/jajaf_lambda_edge"
  project_name = "myproject"
  ip_whitelist = [
    "12.12.12.12",
    "13.13.13.13"
  ]
}

*/
