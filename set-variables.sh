#!/usr/bin/env bash

variables_file_path=/etc/profile.d/vay-variables.sh
nginx_template_path=/etc/nginx/nginx.conf.template
nginx_config_path=/etc/nginx/conf.d/nginx.conf
nginx_html_path=/usr/share/nginx/html

sleep 5

IP=$(ifconfig | grep inet | grep -v 127.0.0.1 | awk '{print $2}')
echo "$IP let.me.play" >> /etc/hosts

# Get Nginx version and compile informations

command="nginx -V" && nginxv=$( ${command} 2>&1 )

cat <<EOF > $nginx_html_path/nginx_info.txt
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  Nginx and compile information after built:
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
$(echo $nginxv)

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
EOF


# Set Dockerfile to show on the nginx

cat <<EOF > $nginx_html_path/Dockerfile.txt
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
# My Dockerfile:                                             
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
$(cat /usr/share/nginx/html/Dockerfile)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
EOF

# Get human readable ssl certificate to show on the nginx
  cat <<EOF > $nginx_html_path/ssl_cert.html
<meta http-equiv="REFRESH" content="30; url=https://let.me.play:10443/ssl_cert.html">
<html>
<body>
  <p>+++++++++++++++++++++++++++++++++++++++++++++++</p>
  <h1> Human Readable SSL Certificate: </h1>
  <h2>$(openssl s_client -showcerts -connect let.me.play:10443 < /dev/null 2> /dev/null | openssl x509 -noout -enddate)</h2>
  <h2> This page will be refreshed every 30 seconds</h2>
  <p>+++++++++++++++++++++++++++++++++++++++++++++++</p>
</body>
</html>
EOF


# Infinite loop for running on the background to get VARIABLES at the moment

while true
do

# Set system's available entropy
  echo "export SYSTEM_ENTROPY=$(cat /proc/sys/kernel/random/entropy_avail)" > $variables_file_path

  cat <<EOF > $nginx_html_path/system_entropy.html
<meta http-equiv="REFRESH" content="5; url=https://let.me.play:10443/system_entropy.html">
<html>
<body>
  <p>+++++++++++++++++++++++++++++++++++++++++++++++</p>
  <h1> System's entropy is: $(cat /proc/sys/kernel/random/entropy_avail)</h1>
  <p> </p>
  <h2> This value will be changed every 5 seconds</h2>
  <p>+++++++++++++++++++++++++++++++++++++++++++++++</p>
</body>
</html>
EOF

# Set load avarage
  echo "export LOAD_AVARAGE=$(uptime | tr ',' ' ' | awk '{print $10}')" >> $variables_file_path

  cat <<EOF > $nginx_html_path/system_load_average.html
<meta http-equiv="REFRESH" content="5; url=https://let.me.play:10443/system_load_average.html">
<html>
<body>
  <p>+++++++++++++++++++++++++++++++++++++++++++++++</p>
  <h1> System load average is: $(uptime | tr ',' ' ' | awk '{print $10}')"</h1>
  <p> </p>
  <h2> This value will be changed every 5 seconds</h2>
  <p>+++++++++++++++++++++++++++++++++++++++++++++++</p>
</body>
</html>
EOF

  source $variables_file_path

# Get connected devices to show on the nginx
  cat <<EOF > $nginx_html_path/connected_devices.txt
++++++++++++++++++++++++++++++++++++++++++++++++
 List of disks:
++++++++++++++++++++++++++++++++++++++++++++++++
$(lsblk)
++++++++++++++++++++++++++++++++++++++++++++++++
 List of pci :
++++++++++++++++++++++++++++++++++++++++++++++++
$(lspci)
++++++++++++++++++++++++++++++++++++++++++++++++
 List of usb :
++++++++++++++++++++++++++++++++++++++++++++++++
$(lsusb)
++++++++++++++++++++++++++++++++++++++++++++++++
EOF

# Get kernel modules to show on the nginx
  cat <<EOF > $nginx_html_path/kernel_modules.txt
+++++++++++++++++++++++++++++++++++++++++++++++
 Docker Host Kernel Modules:
+++++++++++++++++++++++++++++++++++++++++++++++
$(lsmod)
+++++++++++++++++++++++++++++++++++++++++++++++
EOF

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

