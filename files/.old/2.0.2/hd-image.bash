#!/bin/bash

# hd-image: a tool for managing the HD Image
# Created by Max Narvaez

show_help() {
    echo "Hardware Design Image Tool"
    echo
    echo "Options:"
    echo "-h,   --help          show this help message"
    echo "-v,   --version       show the current version of the image"
    echo "-i,   --info          show information about this Pi"
    echo "      --report        send info to PiTracker server"
    echo "      --update        check for image updates"
    echo "                      (this happens automatically at startup"
    echo "                       and at 5am each day)"
    exit 0
}

info() {
    IMAGEVER=`cat /usr/HD/version`
    SERIAL=`cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2`
    IP=`hostname -I`
    ipa=1
    for ip in $IP
    do
        j=`echo $ip | cut -d ' ' -f $ipa`
        if echo $j | grep "10.44." &> /dev/null
        then
            IP=$j
            break
        fi
    done
    MAC=`ifconfig wlan0 | grep ether | sed 's/  \+/ /g' | cut -d ' ' -f 3`
    SDSERIAL=`cat /sys/block/mmcblk0/device/cid`
    HARDREV=`cat /proc/cpuinfo | grep Revision | cut -d ' ' -f 2`
    OWNER=`cat /etc/owner`

    echo "Image Version:        $IMAGEVER"
    echo "Hardware Revision:    $HARDREV"
    echo "Pi Serial Number:     $SERIAL"
    echo "SD Serial Number:     $SDSERIAL"
    echo "WiFi IP:              $IP"
    echo "WiFi MAC:             $MAC"
    echo "Owner:                $OWNER"
}

report() {
    /usr/HD/PiTracker.bash
}

update() {
    # Test for internet connection
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

    /usr/local/bin/ansible-pull \
    -U https://gitlab+deploy-token-12:sErpRQP96JzfVponpBh-@stogit.cs.stolaf.edu/hd-image/hd-image.git \
    -e imgVersion=`cat /usr/HD/version`

    report | /usr/bin/logger -t PiTracker
}

while test $# -gt 0
do
    case "$1" in
        -h|--help)
            show_help
            ;;
        -v|--version)
            shift
            cat /usr/HD/version
            echo
            exit 0
            ;;
        --update)
            shift
            update
            exit 0
            ;;
        -i|--info)
            shift
            info
            exit 0
            ;;
        --report)
            shift
            report
            exit 0
            ;;
        *)
            show_help
            ;;
    esac
    exit 0
done

show_help
