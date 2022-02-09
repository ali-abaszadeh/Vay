#!/usr/bin/env bash

variables_file_path=/etc/profile.d/vay-variables.sh
nginx_template_path=/etc/nginx/nginx.conf.template
nginx_config_path=/etc/nginx/conf.d/nginx.conf
nginx_html_path=/usr/shae/nginx/html

sleep 5

# Get Nginx version and compile informations
cat <<EOF > $nginx_html_path/nginx_info.html
<html>
<body>
  <p>Nginx and compile information after built: $(nginx -V)</p>
</body>
</html>
EOF


# Set Dockerfile to show on the nginx
cat <<EOF > $nginx_html_path/Dockerfile.html
<html>
<body>
  <p>$(cat /usr/share/nginx/html/Dockerfile)</p>
</body>
</html>
EOF

# Get connected devices to show on the nginx
cat <<EOF > $nginx_html_path/Connected_devices.html
<html>
<body>
  <p>$(Command will be needed)</p>
</body>
</html>
EOF

# Get kernel modules to show on the nginx
cat <<EOF > $nginx_html_path/kernel_modules.html
<html>
<body>
  <p>$(Comand will be needed)</p>
</body>
</html>
EOF

# Get human readable ssl certificate to show on the nginx
cat <<EOF > $nginx_html_path/ssl_cert.html
<html>
<body>
  <p>$(Comand will be needed)</p>
</body>
</html>
EOF


# Infinite loop for running on the background to get VARIABLES at the moment

while true
do
  	
# Set system's available entropy
  echo "export SYSTEM_ENTROPY=$(cat /proc/sys/kernel/random/entropy_avail)" > $variables_file_path
  
  cat <<EOF > $nginx_html_path/system_entropy.html
<html>
<body>
  <p> System's entropy is: $(cat /proc/sys/kernel/random/entropy_avail)</p>
  <p> This value will be changed every 10 seconds</p>
</body>
</html>
EOF

# Set load avarage
  echo "export LOAD_AVARAGE=$(uptime | tr ',' ' ' | awk '{print $10}')" >> $variables_file_path
  
  cat <<EOF > $nginx_html_path/load_average.html
<html>
<body>
  <p> System load average is: $(uptime | tr ',' ' ' | awk '{print $10}')"</p>
  <p> This value will be changed every 10 seconds</p>
</body>
</html>
EOF

  source $variables_file_path

# Set new values for "system's entropy" and "load avarage" in the nginx.conf

  set -eu

  envsubst '${SYSTEM_ENTROPY} ${LOAD_AVARAGE}' < $nginx_template_path > $nginx_config_path

  # exec "$@" is typically used to make the entrypoint a pass through that then runs the docker command. 
  # It will replace the current running shell with the command that "$@" is pointing to
  # Its important for process handeling in container.
  
  exec "$@"

  nginx -s reload

  sleep 5

done
