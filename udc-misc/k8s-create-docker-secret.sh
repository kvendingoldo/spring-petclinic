#!/usr/bin/env bash

########################################################
#
# Name: k8s-create-docker-secret.sh
#
##########################################################

SECRET_NAME='udc-registry'
DOCKER_EMAIL='kvendingoldo@gmail.com'
APP_NAMESPACE='application'

# create a GCP service account; format of account is email address
SA_EMAIL=$(gcloud iam service-accounts --format='value(email)' create k8s-gcr-auth-ro)

# create the json key file and associate it with the service account
gcloud iam service-accounts keys create k8s-gcr-auth-ro.json --iam-account=${SA_EMAIL}

# get the project id
PROJECT=$(gcloud config list core/project --format='value(core.project)')

# add the IAM policy binding for the defined project and service account
gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:${SA_EMAIL} --role roles/storage.objectViewer

# change namespace
kubectl config set-context $(kubectl config current-context) --namespace=${APP_NAMESPACE}

# create k8s secret
kubectl create secret docker-registry ${SECRET_NAME} \
  --docker-server=https://gcr.io \
  --docker-username=_json_key \
  --docker-email=${DOCKER_EMAIL} \
  --docker-password="$(cat k8s-gcr-auth-ro.json)"

# add secret to the default service account
kubectl patch serviceaccount default \
  -p "{\"imagePullSecrets\": [{\"name\": \"${SECRET_NAME}\"}]}"
