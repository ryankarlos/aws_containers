### Deploying a dummy FAST API app in ECS with Load Balancer and WAF

This terraform parent module, deploys a very basic fast api web application (stored in app folder in the root of the repo) to ECS service using FARGATE with autoscaling using step scaling policy. 

It automatically configues a load balancer in front of this service listening to https and http traffic and redirect to target group containing the running application. 

Docker image with app code and dependencies are automatically built when running terraform code and pushed to ECR. A variable `force_image_rebuild` is used to determine if  the image is always built and pushed with every run or just when the source code is changed (determined by SHA256 hash of the contents of the files in the source code repo containing the dockerfile). Please see the ECR module for more details on the implementation.

We need to add a SSL certificate when configuring https on the load balanacer listener. This can be done either by generating a public/private certificate in ACM or using self signed certicate generated externally. 
If using ACM, you will need to have a domain to associate with the certificate (which can be registered via route53 along with a hosted zone with records for the domain and subdomain for routing traffic to load balancer)

Here we will use  a self signed SSL certificate and private key uploaded to IAM and just use the public DNS on load balancer to access the web app hosted in ECS.


First `cd` to this ecs-lb folder and run the following commands

* generate a private key using RSA algorithm (2048 bits) 


```bash
openssl genpkey -algorithm RSA -out key.pem -pkeyopt rsa_keygen_bits:2048
```

* Using the private key, create a new self signed certificate with a year expiry (or a shorter period)

```bash
openssl req -new -x509 -key key.pem -out cert.pem -days 365
```


* optionally, we can print the self signed cert to stdout 

```bash
openssl x509 -text -noout -in cert.pem 
```


Now you should have key.pem and cert.pem file in the ecs-lb folder. The terraform script will fetch the file contents from these and create iam cert resource which will be associated with the load balancer https listener.


Add a tfvars in this folder and populate values for the following required variables:

```
region          = "us-east-1" 
vpc_id          = "vpc-..."
subnets         = ["subnet-...", "subnet-...."]
security_groups = ["sg-....."]

credentials = {
  cert = "cert.pem"
  pk   = "key.pem"
}

repository_name = "fast_api_ecs"
dkr_img_src_path = "<path-to-app-folder-in-this-repo> e.g. "Users/jbloggs/Documents/aws_containers/app"
force_image_rebuild = false
```


```bash 
cd terraform/ecs-lb
terraform init
terraform plan 
terraform apply
```

Navigate to the DNS name of the load balancer and paste it in browser with a /docs at the end e.g  http://default-load-balancer-......us-east-1.elb.amazonaws.com/docs

You should see thE FASTAPI doc where you can test out the endpoint.

You should also be able to navigate to https link (since we are using a self seigned certificate, the browser may give you a security risk warning which you will need to accept to be directed to the site)


When you have finished, tear down the resources to avoid incurring costs

```
terraform destroy
```