gcloud container clusters get-credentials accelerator-cluster --zone us-east1-b --project GSA_PROJECT

kubectl apply -f nginx-ingress.yaml

export IP="$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath="{.status.loadBalancer.ingress[0].ip}")"

gcloud dns record-sets transaction start --zone=XYZ-com

gcloud dns record-sets transaction add  $IP   --name=nginx-ingress.XYZ.com  --ttl=300    --type=A    --zone=XYZ-com

gcloud dns record-sets transaction execute --zone=XYZ-com

s="prov"

while [ "$s" != "Active" ]
do
    export s=`(kubectl get managedcertificate jenkins-test-cert -n jenkins -o jsonpath="{.status.certificateStatus}")`
done
