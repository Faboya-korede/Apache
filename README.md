# Deploying a HTML Site with Terraform

This project demonstrates how to use Terraform to deploy a simple HTML site to AWS using EC2 instances and an Elastic Load Balancer (ELB). The project includes the following steps:

- Use Terraform to create 3 EC2 instances and put them behind an ELB.
- Export the public IP addresses of the 3 instances to a file called `host-inventory`.
- Set up a domain name using AWS Route53 within the Terraform plan, and add an A record for a subdomain called `terraform-test` that points to the ELB IP address.
- Use Ansible to install Apache and set the timezone to `Africa/Lagos` on all 3 EC2 instances.
- Display a simple HTML page on all 3 instances that clearly identifies them.
- Ensure that when someone visits `terraform-test.yourdomain.com`, it shows the content from the instances and rotates between the servers as the page is refreshed.

## Prerequisites

Before you begin, you will need:

- An AWS account
- Terraform installed on your local machine
- An SSH key pair for connecting to the EC2 instances
- Ansible installed on your local machine

## Usage

1. Clone this repository to your local machine.
2. Modify the `variables.tf` file to match your AWS configuration.
3. Run `terraform init` to initialize Terraform and download any necessary plugins.
4. Run `terraform apply` to create the infrastructure.
5. Once the infrastructure is created, run the Ansible playbook using `ansible-playbook -i host-inventory playbook.yml`.
6. Visit `terraform-test.yourdomain.com` in your browser to see the deployed site.

## Conclusion

By following the steps outlined in this project, you can easily deploy a simple HTML site to AWS using Terraform and Ansible.
