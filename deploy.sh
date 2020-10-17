cd terraform || exit
terraform init
terraform apply -auto-approve -var-file terraform.tfvars
cd ../docker || exit
./build-tag-push.sh
cd ../terraform || exit
terraform apply -auto-approve -var-file terraform.tfvars
