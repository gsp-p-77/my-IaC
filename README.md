# my-IaC

This repository is intended to specify my frequently used server instances following the "Infrastrucure as a code" approach.

All server instances will be specified below the servers folder, which contain sub folders for different classes of servers.

Below the server class (e.g. docker-engine), the IaC files can be found below different kinds of technologies (e.g. vagrant)


## Prerequisites
tbd

## Vagrant usage

## Terraform usage

### General
- cd into folder with terraform file
- terraform init
- terraform validate
- terraform plan
- terraform apply
- cat terraform.tfstate
- terraform destroy

### ssh
aws ec2 describe-instances --filters \
"Name=instance-state-name,Values=running" \
--query "Reservations[*].Instances[*].[InstanceId,Tags[?Key=='Name'].Value|[0],PublicIpAddress]" \
--output table

ssh -i /path/to/your-private-key.pem ubuntu@<public-ip-address>

