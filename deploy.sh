#!/usr/bin/env bash

# Build docker images
docker build -t earlpomeroy/multi-client:latest -t earlpomeroy/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t earlpomeroy/multi-server:latest -t earlpomeroy/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t earlpomeroy/multi-worker:latest -t earlpomeroy/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# Push images to Docker Hub
docker push earlpomeroy/multi-client:latest
docker push earlpomeroy/multi-server:latest
docker push earlpomeroy/multi-worker:latest

docker push earlpomeroy/multi-client:$SHA
docker push earlpomeroy/multi-server:$SHA
docker push earlpomeroy/multi-worker:$SHA

# Apply images to kubernetes
kubectl apply -f k8s

# Set deployment images
kubectl set image deployments/server-deployment server=earlpomeroy/multi-server:$SHA
kubectl set image deployments/client-deployment client=earlpomeroy/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=earlpomeroy/multi-worker:$SHA
