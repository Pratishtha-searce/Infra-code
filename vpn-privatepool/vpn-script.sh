gcloud compute vpn-gateways create gke-cluster-accelerator-vpn-gateway \
   --network=gke-cluster-accelerator-vpc	 \
   --region=us-east1 \
   --stack-type=IPV4_ONLY


gcloud compute vpn-gateways create private-pool-accelerator-vpn-gateway \
   --network=private-pool-accelerator-vpc \
   --region=us-east1 \
   --stack-type=IPV4_ONLY


gcloud compute routers create vpn-gke-cluster-accelerator-vpc \
   --region=us-east1 \
   --network=gke-cluster-accelerator-vpc	 \
   --asn=64518


gcloud compute routers create vpn-private-pool-accelerator-vpc \
   --region=us-east1 \
   --network=private-pool-accelerator-vpc \
   --asn=64522


gcloud compute vpn-tunnels create gke-cluster-accelerator-vpc-0 \
    --peer-gcp-gateway=private-pool-accelerator-vpn-gateway \
    --region=us-east1 \
    --ike-version=2 \
    --shared-secret=e959060652d0eee39c40312c7916d076 \
    --router=vpn-gke-cluster-accelerator-vpc \
    --vpn-gateway=gke-cluster-accelerator-vpn-gateway \
    --interface=0


gcloud compute vpn-tunnels create private-pool-accelerator-vpc-0 \
    --peer-gcp-gateway=gke-cluster-accelerator-vpn-gateway \
    --region=us-east1 \
    --ike-version=2 \
    --shared-secret=e959060652d0eee39c40312c7916d076 \
    --router=vpn-private-pool-accelerator-vpc \
    --vpn-gateway=private-pool-accelerator-vpn-gateway \
    --interface=0


gcloud compute routers add-interface vpn-gke-cluster-accelerator-vpc \
    --interface-name=gke-cluster-accelerator-vpc-0 \
    --ip-address=169.254.0.1 \
    --mask-length=16 \
    --vpn-tunnel=gke-cluster-accelerator-vpc-0 \
    --region=us-east1


gcloud compute routers add-bgp-peer vpn-gke-cluster-accelerator-vpc \
    --peer-name=gke-cluster-accelerator-vpn-gateway \
    --interface=gke-cluster-accelerator-vpc-0 \
    --peer-ip-address=169.254.0.2 \
    --peer-asn=64522 \
    --region=us-east1


gcloud compute routers add-interface vpn-private-pool-accelerator-vpc \
    --interface-name=private-pool-accelerator-vpc-0 \
    --ip-address=169.254.0.2 \
    --mask-length=16 \
    --vpn-tunnel=private-pool-accelerator-vpc-0 \
    --region=us-east1


gcloud compute routers add-bgp-peer vpn-private-pool-accelerator-vpc \
    --peer-name=private-pool-accelerator-vpn-gateway \
    --interface=private-pool-accelerator-vpc-0 \
    --peer-ip-address=169.254.0.1 \
    --peer-asn=64518 \
    --region=us-east1


