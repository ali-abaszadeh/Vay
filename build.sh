#!/bin/bash

nginx_service_name=nginx_custom_vay

# Build the nginx image
echo "++++++++++++++++++++++++++++++++++++++"
echo "+ Starting build the nginx image ... +"
echo "++++++++++++++++++++++++++++++++++++++"
echo ""
docker-compose build
echo ""

# Run the nginx container
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+ Run nginx container from the nginx custom image ... +"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""
docker-compose up -d
echo ""

# Run set-variables.sh script on the container
sleep 6
docker-compose exec -d -u 0 $nginx_service_name /set-variables.sh 
