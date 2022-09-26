gcloud compute vpn-gateways create gke-cluster-vpn-gateway \
   --network=gke-cluster-vpc	 \
   --region=us-east1 \
   --stack-type=IPV4_ONLY


gcloud compute vpn-gateways create private-pool-vpn-gateway \
   --network=private-pool-vpc \
   --region=us-east1 \
   --stack-type=IPV4_ONLY


gcloud compute routers create vpn-gke-cluster-vpc \
   --region=us-east1 \
   --network=gke-cluster-vpc	 \
   --asn=64518


gcloud compute routers create vpn-private-pool-vpc \
   --region=us-east1 \
   --network=private-pool-vpc \
   --asn=64522


gcloud compute vpn-tunnels create gke-cluster-vpc-0 \
    --peer-gcp-gateway=private-pool-vpn-gateway \
    --region=us-east1 \
    --ike-version=2 \
    --shared-secret=e959060652d0eee39c40312c7916d076 \
    --router=vpn-gke-cluster-vpc \
    --vpn-gateway=gke-cluster-vpn-gateway \
    --interface=0


gcloud compute vpn-tunnels create private-pool-vpc-0 \
    --peer-gcp-gateway=gke-cluster-vpn-gateway \
    --region=us-east1 \
    --ike-version=2 \
    --shared-secret=e959060652d0eee39c40312c7916d076 \
    --router=vpn-private-pool-vpc \
    --vpn-gateway=private-pool-vpn-gateway \
    --interface=0


gcloud compute routers add-interface vpn-gke-cluster-vpc \
    --interface-name=gke-cluster-vpc-0 \
    --ip-address=169.254.0.1 \
    --mask-length=16 \
    --vpn-tunnel=gke-cluster-vpc-0 \
    --region=us-east1


gcloud compute routers add-bgp-peer vpn-gke-cluster-vpc \
    --peer-name=gke-cluster-vpn-gateway \
    --interface=gke-cluster-vpc-0 \
    --peer-ip-address=169.254.0.2 \
    --peer-asn=64522 \
    --region=us-east1


gcloud compute routers add-interface vpn-private-pool-vpc \
    --interface-name=private-pool-vpc-0 \
    --ip-address=169.254.0.2 \
    --mask-length=16 \
    --vpn-tunnel=private-pool-vpc-0 \
    --region=us-east1


gcloud compute routers add-bgp-peer vpn-private-pool-vpc \
    --peer-name=private-pool-vpn-gateway \
    --interface=private-pool-vpc-0 \
    --peer-ip-address=169.254.0.1 \
    --peer-asn=64518 \
    --region=us-east1


