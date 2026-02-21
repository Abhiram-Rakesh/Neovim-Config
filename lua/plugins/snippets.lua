return {
  aws = {
    s3_ls = {
      prefix = 'aws-s3-ls',
      body = { 'aws s3 ls s3://${1:bucket-name}/' },
      description = 'List S3 bucket contents',
    },
    s3_cp = {
      prefix = 'aws-s3-cp',
      body = { 'aws s3 cp ${1:source} s3://${2:bucket}/${3:path}' },
      description = 'Copy file to S3',
    },
    ec2_ls = {
      prefix = 'aws-ec2-ls',
      body = { 'aws ec2 describe-instances --filters "Name=instance-state-name,Values=running"' },
      description = 'List running EC2 instances',
    },
    ecs_ls = {
      prefix = 'aws-ecs-ls',
      body = { 'aws ecs list-clusters' },
      description = 'List ECS clusters',
    },
    ecr_login = {
      prefix = 'aws-ecr-login',
      body = { 'aws ecr get-login-password | docker login --username AWS --password-stdin ${1:account-id}.dkr.ecr.${2:region}.amazonaws.com' },
      description = 'Login to ECR',
    },
    lambda_inv = {
      prefix = 'aws-lambda-inv',
      body = { 'aws lambda invoke --function-name ${1:function-name} --payload \'${2:{}}\' ${3:response.json}' },
      description = 'Invoke Lambda function',
    },
  },
  gcp = {
    gcs_ls = {
      prefix = 'gcp-gcs-ls',
      body = { 'gsutil ls gs://${1:bucket-name}/' },
      description = 'List GCS bucket contents',
    },
    gcs_cp = {
      prefix = 'gcp-gcs-cp',
      body = { 'gsutil cp ${1:source} gs://${2:bucket}/${3:path}' },
      description = 'Copy file to GCS',
    },
    gke_creds = {
      prefix = 'gcp-gke-creds',
      body = { 'gcloud container clusters get-credentials ${1:cluster-name} --region=${2:region}' },
      description = 'Get GKE credentials',
    },
    gce_ls = {
      prefix = 'gcp-gce-ls',
      body = { 'gcloud compute instances list' },
      description = 'List GCE instances',
    },
    run_deploy = {
      prefix = 'gcp-run-deploy',
      body = { 'gcloud run deploy ${1:service-name} --image gcr.io/${2:project}/${3:image}:${4:tag} --platform managed --region ${5:region}' },
      description = 'Deploy to Cloud Run',
    },
  },
  azure = {
    storage_ls = {
      prefix = 'az-storage-ls',
      body = { 'az storage blob list --container-name ${1:container} --account-name ${2:account}' },
      description = 'List storage blob contents',
    },
    storage_cp = {
      prefix = 'az-storage-cp',
      body = { 'az storage blob upload --container-name ${1:container} --name ${2:path} --file ${3:file} --account-name ${4:account}' },
      description = 'Upload blob to storage',
    },
    vm_ls = {
      prefix = 'az-vm-ls',
      body = { 'az vm list --resource-group ${1:rg}' },
      description = 'List VMs in resource group',
    },
    aks_creds = {
      prefix = 'az-aks-creds',
      body = { 'az aks get-credentials --resource-group ${1:rg} --name ${2:cluster}' },
      description = 'Get AKS credentials',
    },
    func_deploy = {
      prefix = 'az-func-deploy',
      body = { 'az functionapp deployment source config-local-git --resource-group ${1:rg} --name ${2:function-app}' },
      description = 'Configure function app for local git deployment',
    },
  },
  k8s = {
    k8s_get_pods = {
      prefix = 'k8s-get-pods',
      body = { 'kubectl get pods -n ${1:namespace}' },
      description = 'Get pods in namespace',
    },
    k8s_describe_pod = {
      prefix = 'k8s-describe-pod',
      body = { 'kubectl describe pod ${1:pod-name} -n ${2:namespace}' },
      description = 'Describe pod',
    },
    k8s_logs = {
      prefix = 'k8s-logs',
      body = { 'kubectl logs ${1:pod-name} -n ${2:namespace} ${3:--follow}' },
      description = 'Get pod logs',
    },
    k8s_exec = {
      prefix = 'k8s-exec',
      body = { 'kubectl exec -it ${1:pod-name} -n ${2:namespace} -- /bin/sh' },
      description = 'Exec into pod',
    },
    k8s_apply = {
      prefix = 'k8s-apply',
      body = { 'kubectl apply -f ${1:file.yaml}' },
      description = 'Apply kubernetes manifest',
    },
    k8s_context = {
      prefix = 'k8s-context',
      body = { 'kubectl config use-context ${1:context-name}' },
      description = 'Switch kubernetes context',
    },
  },
  docker = {
    docker_build = {
      prefix = 'docker-build',
      body = { 'docker build -t ${1:image}:${2:tag} ${3:.}' },
      description = 'Build Docker image',
    },
    docker_run = {
      prefix = 'docker-run',
      body = { 'docker run -d --name ${1:container-name} ${2:image}' },
      description = 'Run Docker container',
    },
    docker_push = {
      prefix = 'docker-push',
      body = { 'docker push ${1:image}:${2:tag}' },
      description = 'Push Docker image',
    },
    docker_compose = {
      prefix = 'docker-compose',
      body = { 'docker-compose up -d${1: --build}' },
      description = 'Start docker-compose services',
    },
  },
}
