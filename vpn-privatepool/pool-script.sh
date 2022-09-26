gcloud compute addresses create worker-pool-range \
    --global \
    --purpose=VPC_PEERING \
    --addresses=192.168.0.0 \
    --prefix-length=24 \
    --network=private-pool-vpc


gcloud services vpc-peerings connect \
    --service=servicenetworking.googleapis.com \
    --ranges=worker-pool-range \
    --network=private-pool-vpc


gcloud compute networks peerings update servicenetworking-googleapis-com \
    --network=private-pool-vpc \
    --export-custom-routes \
    --no-export-subnet-routes-with-public-ip


gcloud builds worker-pools create private-pool \
   --region=us-east1 \
   --peered-network=projects/PROJECT_ID/global/networks/private-pool-vpc


export GKE_PEERING_NAME=$(gcloud container clusters describe gke-cluster --zone us-east1-b  --format='value(privateClusterConfig.peeringName)')

gcloud compute networks peerings update $GKE_PEERING_NAME --network=gke-cluster-vpc --export-custom-routes --no-export-subnet-routes-with-public-ip

gcloud compute networks peerings update servicenetworking-googleapis-com --network=private-pool-vpc --export-custom-routes --no-export-subnet-routes-with-public-ip

IP=`gcloud compute addresses describe worker-pool-range --global | grep address:| awk '{print $2}'`

gcloud compute routers update-bgp-peer vpn-private-pool-vpc --peer-name=private-pool-vpn-gateway --region=us-east1 --advertisement-mode=CUSTOM --set-advertisement-ranges=$IP/24

gcloud compute routers update-bgp-peer 	vpn-gke-cluster-vpc --peer-name=gke-cluster-vpn-gateway --region=us-east1 --advertisement-mode=CUSTOM --set-advertisement-ranges=10.4.0.0/28

gcloud container clusters update gke-cluster --enable-master-authorized-networks --zone us-east1-b --master-authorized-networks=$IP/24