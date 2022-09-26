wget ${_JENKINSURL_}jnlpJars/jenkins-cli.jar

envsubst < creds.xml > custom-creds.xml

envsubst < review-job.xml > custom-review-job.xml

gcloud container clusters get-credentials gke-cluster --zone us-east1-b --project PROJECT_ID

export POD_NAME="$(kubectl get pods --no-headers -o custom-columns=":metadata.name" -n jenkins | grep jenkins)"

export PASSWORD="$(kubectl exec $POD_NAME -n jenkins -- /bin/bash -c "cat /var/jenkins_home/secrets/initialAdminPassword")"

java -jar jenkins-cli.jar -s ${_JENKINSURL_} -auth admin:$PASSWORD -webSocket install-plugin docker-workflow:1.29

java -jar jenkins-cli.jar -s ${_JENKINSURL_} -auth admin:$PASSWORD -webSocket install-plugin google-container-registry-auth:0.3

java -jar jenkins-cli.jar -s ${_JENKINSURL_} -auth admin:$PASSWORD -webSocket install-plugin github:1.34.4

java -jar jenkins-cli.jar -s ${_JENKINSURL_} -auth admin:$PASSWORD -webSocket install-plugin google-kubernetes-engine:0.8.7 -restart

sleep 120

java -jar jenkins-cli.jar -s ${_JENKINSURL_} -auth admin:$PASSWORD -webSocket create-credentials-by-xml system::system::jenkins "(global)" < custom-creds.xml

java -jar jenkins-cli.jar -s ${_JENKINSURL_} -auth admin:$PASSWORD -webSocket create-job review-job < custom-review-job.xml

java -jar jenkins-cli.jar -s ${_JENKINSURL_} -auth admin:$PASSWORD -webSocket groovy = < token.groovy

kubectl exec $POD_NAME -n jenkins -- /bin/bash -c "cat /var/jenkins_home/token.txt" > token.txt

gcloud secrets create token-secret --data-file=token.txt

rm -rf token.txt