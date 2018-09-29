#!/usr/bin/env bash

########################################################
#
# Name: entrypoint.sh
#
##########################################################

java -jar ${BASE_DIR}/udc-backend-service.jar --spring.config.location="${BASE_DIR}/properties/application.properties"
