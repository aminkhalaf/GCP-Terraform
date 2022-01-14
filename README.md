# GCP-Terraform-Project

## Infrastructure Using Terraform
A VPC containing 2 subnets, Nat gateway, Private VM and a private standard gke cluster.

## Docker image
I dockerized this python app using docker file & docker compose.

## Installation
Using pip package manager to install dependencies into your Docker file.

```bash
RUN pip install -r requirements.txt
```

Apply infrastructure on GCP using Terraform.

```bash
terraform init 
terraform plan
terraform apply
```