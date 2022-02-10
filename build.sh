#!/bin/bash

START_TIME=$(date)

nginx_service_name=nginx_custom_vay

cp Dockerfile data/Dockerfile

# Build the nginx image
echo "++++++++++++++++++++++++++++++++++++++"
echo "+ Starting build the nginx image ... +"
echo "++++++++++++++++++++++++++++++++++++++"
echo ""
docker-compose build
echo ""
echo ""

# Run the nginx container
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+ Run nginx container from the nginx custom image ... +"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""
docker-compose up -d
echo ""
echo ""

# Run set-variables.sh script on the container
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+ Run set-variables.sh script on the container ...    +"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
sleep 6
docker-compose exec -d -u 0 $nginx_service_name /set-variables.sh 
echo ""
echo ""

END_TIME=$(date)
echo "++++++++++++++++++++++++++++++"
echo "+++ Start time: $START_TIME +++"
echo "++++++++++++++++++++++++++++++"
echo ""
echo "++++++++++++++++++++++++++++++"
echo "+++ End time: $END_TIME +++"
echo "++++++++++++++++++++++++++++++"
echo ""
echo ""

