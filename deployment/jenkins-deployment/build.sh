gcloud compute addresses create jenkins-ip \
    --global \
    --ip-version IPV4

IP=`gcloud compute addresses describe jenkins-ip --global | grep address:| awk '{print $2}'`

gcloud dns record-sets transaction start --zone=ZONE_NAME

gcloud dns record-sets transaction add  $IP   --name=jenkins.XXXX.com  --ttl=300    --type=A    --zone=ZONE_NAME

gcloud dns record-sets transaction execute --zone=ZONE_NAME

gcloud container clusters get-credentials gke-cluster --zone us-east1-b --project PROJECT_ID

kubectl apply -f storageclass.yaml

kubectl apply -f pvc.yaml

kubectl apply -f jenkins.yaml

kubectl apply -f cert.yaml

kubectl apply -f ingress.yaml

gcloud iam service-accounts add-iam-policy-binding workload-identity-test@PROJECT_ID.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:PROJECT_ID.svc.id.goog[jenkins/jenkins]"

kubectl annotate serviceaccount jenkins --namespace jenkins iam.gke.io/gcp-service-account=workload-identity-test@PROJECT_ID.iam.gserviceaccount.com