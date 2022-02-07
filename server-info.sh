#!/bin/sh

# Show system's available entropy

echo "system's available entropy is: $(cat /proc/sys/kernel/random/entropy_avail)"

export SYSTEM_ENTROPY=$(cat /proc/sys/kernel/random/entropy_avail)

echo "$SYSTEM_ENTROPY"

# Showing the system's load average

echo "load average over the last 1 minute is: $(uptime | tr ',' ' ' | awk '{print $8}')" && \
echo "load average over the last 5 minute is: $(uptime | tr ',' ' ' | awk '{print $9}')" && \
echo "load average over the last 15 minute is: $(uptime | tr ',' ' ' | awk '{print $10}')"

#export LOAD_AVARAGE=`echo "load average over the last 1 minute is: $(uptime | tr ',' ' ' | awk '{print $8}')" && \
#echo "load average over the last 5 minute is: $(uptime | tr ',' ' ' | awk '{print $9}')" && \
#echo "load average over the last 15 minute is: $(uptime | tr ',' ' ' | awk '{print $10}')"`


