#!/usr/bin/env bash

variables_file_path=/etc/profile.d/vay-variables.sh
nginx_template_path=/etc/nginx/nginx.conf.template
nginx_config_path=/etc/nginx/conf.d/nginx.conf
sleep 5

# Infinite loop for running on the background to get VARIABLES at the moment

while true
do
  	
# Set system's available entropy
  echo "export SYSTEM_ENTROPY=$(cat /proc/sys/kernel/random/entropy_avail)" > $variables_file_path

# Set load avarage
  echo "export LOAD_AVARAGE=$(uptime | tr ',' ' ' | awk '{print $10}')" >> $variables_file_path

  source $variables_file_path

# Set new values for "system's entropy" and "load avarage" in the nginx.conf

  set -eu
  envsubst '${SYSTEM_ENTROPY} ${LOAD_AVARAGE}' < $nginx_template_path > $nginx_config_path
  
  exec "$@"

  nginx -s reload

  sleep 10

done
