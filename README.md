# Bubbl Deploy #

## Prerequisites

#### Software

Brackets show versions used while documenting this process.

* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) (0.13.4)
* [Docker] (https://docs.docker.com/get-docker/) (19.03.13)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) (2.0.55)

#### Know Your AWS Account ID

Log into the AWS console. Click your username or company name in the menu at the top right. Select "My Security Credentials".

Your account ID is in the bottom left of this page.

##### Save the account ID in local environment variable AWS_ACCOUNT_ID

For example:

    export AWS_ACCOUNT_ID=123456789012
    
Or you can add it to your .bashrc login script or equivalent so that it is always available.
    
## Deployment

#### Create bucket for Terraform state

Create a private bucket on S3. The name will need to be unique across AWS.  Add this value inside the providers.tf file.
 
This bucket will store the state file which lets Terraform know the current state of the system. When Terraform scripts are applied, it will use this state
to determine which changes need to be made.

#### Prepare Terraform scripts

    cd terraform

Create terraform.tfvars file

    cp terraform.tfvars.example terraform.tfvars
    
Populate the above file with your secrets
    
Add your AWS secrets to the terraform.tfvars file. The AWS keys can be created under the IAM section by creating
a user with admin rights and then going to the "Security Credentials" tab.

#### Intialise Terraform backend

    terraform init
    
You will be asked for the name of a state file. You can call this terraform.tfstate.

#### Run Terraform

From the terraform directory:

    ./run.sh apply
    
#### Push the Docker images to ECR

    cd ../docker
    ./build-tag-push.sh

    

    

