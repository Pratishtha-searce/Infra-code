gcloud compute addresses create accelerator-jenkins \
    --global \
    --ip-version IPV4

IP=`gcloud compute addresses describe accelerator-jenkins --global | grep address:| awk '{print $2}'`

gcloud dns record-sets transaction start --zone=searceinc-net

gcloud dns record-sets transaction add  $IP   --name=jenkins-accelerator.searceinc.net  --ttl=300    --type=A    --zone=searceinc-net

gcloud dns record-sets transaction execute --zone=searceinc-net

gcloud container clusters get-credentials accelerator-cluster --zone us-east1-b --project searce-playground-v1

kubectl apply -f storageclass.yaml

kubectl apply -f pvc.yaml

kubectl apply -f jenkins.yaml

kubectl apply -f ingress.yaml

gcloud iam service-accounts add-iam-policy-binding workload-identity-test@searce-playground-v1.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:searce-playground-v1.svc.id.goog[jenkins/jenkins]"

# kubectl annotate serviceaccount jenkins --namespace jenkins iam.gke.io/gcp-service-account=workload-identity-test@searce-playground-v1.iam.gserviceaccount.com