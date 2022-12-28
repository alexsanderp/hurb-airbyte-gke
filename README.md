# Hurb Airbyte GKE

This repository contains the CI/CD workflows for deploying IAC (terraform) and airbyte to a production cluster on GKE.

### Terraform (IAC)
The project contains a terraform directory that provisions all the architecture needed to maintain the GKE cluster. 

When opening a PR for the main branch, a CI/CD will be executed to run the "terraform plan", check if the output has the expected changes.

When merging a PR in the main branch, a CI/CD will be executed to run "terraform apply" to create or modify resources in GCP.

### Airbyte
Installing and upgrading the airbyte deployment uses helm during CI/CD. 

To customize the airbyte, modify the helm/airbyte/values.yml file. 

When merging a PR in the main branch, a CI/CD will be executed to deploy airbyte in the GKE cluster using helm.

### Airbyte URL
http://airbyte.prorion.io/

### Future improvements:

- cluster separate database (Cloud SQL?)
- management of sensitive values
- HTTPS