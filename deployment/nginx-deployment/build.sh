gcloud container clusters get-credentials gke-cluster --zone us-east1-b --project PROJECT_ID

kubectl apply -f nginx-ingress.yaml

export IP="$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath="{.status.loadBalancer.ingress[0].ip}")"

gcloud dns record-sets transaction start --zone=ZONE_NAME

gcloud dns record-sets transaction add  $IP   --name=nginx-ingress.XXXX.com  --ttl=300    --type=A    --zone=ZONE_NAME

gcloud dns record-sets transaction execute --zone=ZONE_NAME

s="prov"

while [ "$s" != "Active" ]
do
    export s=`(kubectl get managedcertificate jenkins-test-cert -n jenkins -o jsonpath="{.status.certificateStatus}")`
done