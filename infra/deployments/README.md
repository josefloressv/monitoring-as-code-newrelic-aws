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

