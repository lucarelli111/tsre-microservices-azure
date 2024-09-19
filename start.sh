#!/bin/bash

echo "Starting..."
## Start Minikube
#echo "> Creation of Minikube"
#minikube start --cpus=6 --memory 16384 --mount --mount-string="/proc:/host/proc"
kubectl create secret generic datadog-secret --from-literal=api-key=$DD_API_KEY --from-literal=app-key=$DD_APP_KEY
## Reconfigure agent
echo "> Setting up of datadog-agent"
helm install datadog-agent -f ctf/datadog-values.yaml datadog/datadog --set datadog.apiKey=$DD_API_KEY
## Restart kubernetes Deployment and Services
echo "> (Building) Running micro-services"

# Set context to docker
# eval $(minikube -p minikube docker-env)
# Pull all missing images
docker pull redis:alpine
# docker pull mariadb
# docker pull busybox:latest

kubectl apply -f kubernetes-manifests/adservice.yaml
kubectl apply -f kubernetes-manifests/cartservice.yaml
kubectl apply -f kubernetes-manifests/checkoutservice.yaml
kubectl apply -f kubernetes-manifests/currencyservice.yaml
kubectl apply -f kubernetes-manifests/loadgenerator.yaml
kubectl apply -f kubernetes-manifests/productcatalogservice.yaml
kubectl apply -f kubernetes-manifests/recommendationservice.yaml
kubectl apply -f kubernetes-manifests/redis.yaml
kubectl apply -f kubernetes-manifests/shippingservice.yaml

# Skaffold build and run
## Loop until 18 pods are up 
skaffold build --platform=linux/amd64
#until [[ $(kubectl get pods | awk 'END{print NR}') -gt 17 ]]; do skaffold run --platform=linux/amd64; done

echo "> Configuring extras"
# Setting variable to check agent status
export AGENT_POD=$(kubectl get pods | sed -e '/datadog-agent/!d' | sed -n '/cluster/!p' | sed -n '/metrics/!p' | awk -F' ' '{print $1}')
# Configure nginx
#export FRONTEND_LB=$(minikube service frontend-lb --url)
#sudo -E ./ctf/microservices/conf_nginx.sh