#!/usr/bin/env bash

# Infinite loop for running on the background to get VARIABLES at the moment

while true
do

  set -eu

  envsubst '${SYSTEM_ENTROPY} ${LOAD_AVARAGE}' < /etc/nginx/nginx.conf.template > /etc/nginx/conf.d/nginx.conf

  exec "$@"

  nginx -s reload

  sleep 10

done
