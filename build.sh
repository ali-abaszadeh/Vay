#!/bin/bash

nginx_service_name=nginx_custom_vay
nginx_page_path=/usr/share/nginx/html/


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

