# AWS AppStream 2.0 Infrastructure Setup with Terraform

This repository contains Terraform code to provision an AWS infrastructure for an AppStream 2.0 environment. It includes the setup of VPCs, subnets, NAT gateways, security groups, AppStream resources (Image Builders, Fleets, and Stacks), and integration with AWS Directory Service and FSx for Windows File Server.

---

## Features

### VPC Setup

    . Creation of a custom VPC with CIDR block 10.0.0.0/20

    . Public and private subnets across multiple availability zones

    . Internet Gateway (IGW) for internet access

    . NAT Gateway for private subnets' internet connectivity

### AppStream 2.0 Resources

    . Image Builder for creating custom AppStream images

    . Fleet for managing AppStream instances

    . Stack for application deployment and user access

### Directory Services

    . Integration with AWS Directory Service (Microsoft AD)

    . Configuration of FSx for Windows File Server for shared storage

### Security

Security group with ingress and egress rules for AppStream endpoints

Route table associations for public and private subnets

---

## Prerequisites

Before deploying this infrastructure, ensure you have the following:

1. Terraform: Install Terraform CLI version 1.x or higher.

2. AWS Account: Ensure your AWS account has sufficient permissions to create resources (VPC, Subnets, AppStream, Directory Service, FSx, etc.).

3. AWS CLI: Set up and configure the AWS CLI with appropriate credentials.

4. Key Information: Update the provider block in the code with your AWS access_key and secret_key or configure it using environment variables.

---

## Deployment Instructions

1. Clone the Repository:

    git clone <repository-url>
    cd <repository-folder>

2. Initialize Terraform:
Run the following command to initialize the Terraform workspace and download provider plugins:

    terraform init

3. Plan the Infrastructure:
Review the changes that Terraform will make to your AWS environment:

    terraform plan

4. Apply the Infrastructure:
Deploy the infrastructure by running:

    terraform apply

Type yes when prompted to confirm.

5. Verify Deployment:

    . Log in to the AWS Management Console.

    . Navigate to the VPC, AppStream, Directory Service, and FSx sections to confirm the resources have been created successfully.

---

## Resources Created

### VPC and Subnets

#### VPC:

    CIDR Block: 10.0.0.0/20

#### Subnets:

    Public Subnet: 10.0.0.0/24 (AZ: us-east-1a)

    Private Subnet 1: 10.0.1.0/24 (AZ: us-east-1b)

    Private Subnet 2: 10.0.2.0/24 (AZ: us-east-1c)

. Internet Gateway: Enables public internet access for the public subnet.

. NAT Gateway: Provides internet access for resources in private subnets.

### AppStream Resources

1. Image Builder:

    Name: terra-Icobatch

    Instance Type: stream.standard.medium

2. Fleet:

Name: fleet-icobatch-automate

Instance Type: stream.standard.medium

Fleet Type: ON_DEMAND

3. Stack:

Name: stacks-automatise-icobatch

Configured user settings for clipboard, file upload/download, and local printing.

4. Fleet-Stack Association:

Associates the fleet with the stack.

### Directory Service and FSx

#### AWS Directory Service (Microsoft AD):

    Name: sucess.com

    Edition: Standard

#### FSx for Windows File Server:

    Storage Capacity: 100 GiB

    Throughput: 1024 MBps

#### Security

    . Security group for AppStream S3 endpoints.

    . Gateway and Interface VPC endpoints for S3 connectivity.