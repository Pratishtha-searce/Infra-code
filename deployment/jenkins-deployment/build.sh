gcloud container clusters get-credentials accelerator-cluster --zone us-east1-b --project GSA_PROJECT

kubectl apply -f storageclass.yaml

kubectl apply -f pvc.yaml

kubectl apply -f jenkins.yaml

kubectl apply -f ingress.yaml

gcloud iam service-accounts add-iam-policy-binding jenkins@GSA_PROJECT.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:PROJECT_ID.svc.id.goog[jenkins/jenkins]"

kubectl annotate serviceaccount jenkins --namespace jenkins iam.gke.io/gcp-service-account=jenkins@GSA_PROJECT.iam.gserviceaccount.com