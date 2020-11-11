terraform $1 -auto-approve -var-file="terraform.tfvars" \
-var="player_count=${2}" \
-var="recorder_count=${3}" \
-var="statsapi_count=${4}" \
-var="dashboard_count=${5}" \
-var="generator_count=${6}"