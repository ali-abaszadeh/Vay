#!/bin/bash

container_name=nginx-custom-vay
nginx_service_name=nginx_custom_vay

docker restart $container_name

# Run set-variables.sh script on the container
sleep 6
docker-compose exec -d -u 0 $nginx_service_name /set-variables.sh

