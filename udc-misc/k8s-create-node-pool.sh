#!/usr/bin/env bash

########################################################
#
# Name: k8s-create-node-pool.sh
#
##########################################################

POOL_NAME='udc-k8s-pool'
CLUSTER_NAME='udc'
CLUSTER_ZONE='europe-west1-b'
# Change storage permissions to storage-rw if you need write to GCR / G Storage
SCOPES='compute-rw,storage-ro,logging-write,monitoring-write'
RAM_PER_NODE='1536'
CPU_PER_NODE='1'

# for enable preemptible VM instances in the new nodepool add --preemptible option
# (in this case you'll have issues with GCR)
gcloud container node-pools create "${POOL_NAME}" \
        --cluster="${CLUSTER_NAME}" \
        --disk-size='15' \
        --disk-type='pd-standard' \
        --enable-autorepair \
        --enable-autoupgrade \
        --image-type='COS' \
        --machine-type="custom-${CPU_PER_NODE}-${RAM_PER_NODE}" \
        --min-cpu-platform='Automatic' \
        --node-version='1.10.7-gke.2' \
        --num-nodes='3' \
        --zone="${CLUSTER_ZONE}" \
        --scopes="${SCOPES}"
