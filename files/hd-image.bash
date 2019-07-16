#!/bin/bash

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
    IMAGEVER=`cat /usr/share/HD/version`
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
    /usr/share/HD/PiTracker.bash
}

update() {
    /usr/local/bin/ansible-pull -o \
    -U https://gitlab+deploy-token-12:sErpRQP96JzfVponpBh-@stogit.cs.stolaf.edu/narvae1/hd-image.git \
    -e imgVersion=`cat /usr/share/HD/version`

    report
}

while test $# -gt 0
do
    case "$1" in
        -h|--help)
            show_help
            ;;
        -v|--version)
            shift
            cat /usr/share/HD/version
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
