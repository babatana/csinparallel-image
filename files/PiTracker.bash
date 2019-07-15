#!/bin/bash

# PiTracker
# Created by Max Narvaez


# Version of the image
IMAGEVER=`cat /usr/share/HD/version`

# IP address of the PiTracker server
SERVERIP="10.44.153.185"

# Test internet connection
tries=0
while ! ping -c 1 -W 2 8.8.8.8 &> /dev/null
do
    if [ $tries -gt 10 ]
    then
        logger "Could not connect to internet"
        exit 1
    fi
    sleep 10
    let "tries++"
done

# Test connection to PiTracker server
ping -c 1 -W 2 $SERVERIP &> /dev/null
if [[ $? != 0 ]]
then
    logger "Could not connect to server"
    exit 2
fi

ansible-pull -o \
-U https://gitlab+deploy-token-12:sErpRQP96JzfVponpBh-@stogit.cs.stolaf.edu/narvae1/hd-image.git \
-e imgVersion=`cat /usr/share/HD/version`

# Get Pi's unique serial number
SERIAL=`cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2`

# Get Pi's St. Olaf Wifi IP address
IP=`hostname -I`
i=1
for ip in $IP
do
    j=`echo $ip | cut -d ' ' -f $i`
    if echo $j | grep "10.44." &> /dev/null
    then
        IP=$j
        break
    fi
done

# Get Pi's Wifi adapter's MAC address
MAC=`ifconfig wlan0 | grep ether | sed 's/  \+/ /g' | cut -d ' ' -f 3`

# Get SD Card's unique serial number
SDSERIAL=`cat /sys/block/mmcblk0/device/cid`

# Get hardware revision (i.e. Pi 3B, Pi 4B - 1GB, etc.)
HARDREV=`cat /proc/cpuinfo | grep Revision | cut -d ' ' -f 2`

# Get name of owner of this Pi
OWNER=`cat /etc/owner`

if [ -z $SERIAL ]
then
    logger "No serial number"
    echo "{\"serialNumber\": \"$SERIAL\", \"macAddress\": \"$MAC\", \
     \"ipAddress\": \"$IP\", \"sdSerialNumber\": \"$SDSERIAL\", \
     \"imageVersion\": \"$IMAGEVER\", \"hardwareVersion\": \"$HARDREV\", \
     \"owner\": \"$OWNER\"}"
    exit 1
fi

# Send data to PiTracker server
curl -i -X POST -H "Content-Type: application/json" $SERVERIP/pis \
-d "{\"serialNumber\": \"$SERIAL\", \"macAddress\": \"$MAC\", \
\"ipAddress\": \"$IP\", \"sdSerialNumber\": \"$SDSERIAL\", \
\"imageVersion\": \"$IMAGEVER\", \"hardwareVersion\": \"$HARDREV\", \
\"owner\": \"$OWNER\"}"
