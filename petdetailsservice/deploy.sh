#!/usr/bin/env bash

export PROJECT=solid-scheme-144804
export CONTAINER_VERSION=feb4v1
export IMAGE=gcr.io/$PROJECT/petdetailsservice:$CONTAINER_VERSION
export BUILD_HOME=.

gcloud config set project $PROJECT
gcloud container clusters get-credentials istio-cluster --zone us-central1-a --project $PROJECT

echo $IMAGE
docker build -t petdetailsservice -f "${PWD}/Dockerfile" $BUILD_HOME
echo 'Successfully built ' $IMAGE

docker tag petdetailsservice $IMAGE
echo 'Successfully tagged ' $IMAGE

#push to google container registry
gcloud docker -- push $IMAGE
echo 'Successfully pushed to Google Container Registry ' $IMAGE

# inject envoy proxy
kubectl apply -f <(istioctl kube-inject -f "${PWD}/kube/petinfo.yaml")
