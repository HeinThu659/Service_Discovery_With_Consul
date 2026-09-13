# AWS Consul Service Discovery Demo 

**service discovery, networking, Terraform, and least-privilege access**  


## AWS Resources

- VPC
- Public / Private Subnets
- Internet Gateway
- Route Tables
- Security Groups
- Dashboard EC2
- Counting EC2
- ASG
- ALB
- S3 Bucket
- S3 Gateway VPC Endpoint
- SSM Interface Endpoint
- IAM Role / Instance Profile
- EC2 Key Pair

All infrastructure is managed with **Terraform**.

## Application Flow

```text
User -> ALB > Dashboard APP > Counting ALB > Counting App
Dashboard :8888
Counting :7777
```

Mangament purpose , use ssm ssh form console  

# TO DO 
## Must has an AWS account and install AWS cli in yout machine  

change the fowllowing two  aws config files with your credentials
```
~/.aws/config
~/.aws/credentials
```

## Terraform

**You Need To Install Terraform First**  
in the root folder **service_dicovery_with_concul**, do the following steps  

Deploy:

```bash
terraform init
terraform plan -var-file={dev.tfvars}
terraform apply -var-file={dev.tfvars} -auto-approve
```
**{dev.tfvars}** is the file if you want to change variables, example file name here is  dev.tfvars.  
you can change later  

Useful outputs:

```text
dashboard_alb_url
s3_bucket_name
```

To Destroy ALL:

```bash
terraform destroy -var-file=dev.tfvars -auto-approve
```

### Destroy Specific Target Resources

For example, destroy the Auto Scaling Groups.

> Note: If an ASG has a desired capacity greater than `0`, it will try to maintain that number of EC2 instances.  
> Simply stopping or terminating an EC2 instance managed by the ASG may cause the ASG to launch a replacement instance.

```bash
terraform destroy \
  -target=aws_autoscaling_group.dashboard \
  -target=aws_autoscaling_group.counting \
  -var-file=dev.tfvars \
  -auto-approve
```
When you want to practice again, recreate them with:  
```bash
terraform apply \
  -target=aws_autoscaling_group.dashboard \
  -target=aws_autoscaling_group.counting \
  -var-file=dev.tfvars \
  -auto-approve
```
