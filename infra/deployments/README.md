# Deployment

Provision AWS S3 bucket:

```sh
aws s3api create-bucket --bucket goweb-terraform-state-bucket
#replace the bucket name in root.hcl

```

Configure environment variables:

```sh
export AWS_ACCESS_KEY_ID=<your-access-key-id>
export AWS_SECRET_ACCESS_KEY=<your-secret-access-key>
export AWS_DEFAULT_REGION=us-east-1
```

# Resources
* [Using the awslogs log driver](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using_awslogs.html#specify-log-config)

# Errors and troubleshooting

*Error: Task stopped ResourceInitializationError*

```
Stopped reason
ResourceInitializationError: unable to pull secrets or registry auth: execution resource retrieval failed: unable to retrieve ecr registry auth: service call has been retried 3 time(s): RequestError: send request failed caused by: Post https://api.ecr.us-east-1.amazonaws.com/: dial tcp 52.46.145.142:443: i/o timeout

```

Solution: This solution needed Public IP active for the container https://aws.amazon.com/premiumsupport/knowledge-center/ecs-unable-to-pull-secrets/


*Error: WARN[] No double-slash (//) found - on remote modules without submodules*

Solution: Added triple slash at the end
```hcl
terraform {
  #source = "${get_parent_terragrunt_dir()}/../modules/stacks/${local.stack_name}/"
  source = "${get_parent_terragrunt_dir()}/../modules/stacks/${local.stack_name}///"
}
```
