gcloud container clusters get-credentials accelerator-cluster --zone us-east1-b --project searce-playground-v1

kubectl apply -f nginx-ingress.yaml

export IP="$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath="{.status.loadBalancer.ingress[0].ip}")"

gcloud dns record-sets transaction start --zone=searceinc-net

gcloud dns record-sets transaction add  $IP   --name=nginx-ingress.searceinc.net  --ttl=300    --type=A    --zone=searceinc-net

gcloud dns record-sets transaction execute --zone=searceinc-net

s="prov"

while [ "$s" != "Active" ]
do
    export s=`(kubectl get managedcertificate jenkins-test-cert -n jenkins -o jsonpath="{.status.certificateStatus}")`
done
