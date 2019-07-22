#!/bin/bash

# hd-image: a tool for managing the HD Image
# Created by Max Narvaez

IMAGEVER=`cat /usr/HD/version`
BRANCH=

show_help() {
    echo "Hardware Design Image Tool $IMAGEVER"
    echo
    echo "Usage: hd-image [-h|-v|info|report|git-fsck|update]"
    echo "Options:"
    echo "-h            show this help message"
    echo "-v            show the current version of the image"
    echo
    echo "info          show information about this Pi"
    echo "report        send info to PiTracker server"
    echo "git-fsck      check all git repositories for errors"
    echo "update        check for image updates"
    echo "              (this happens automatically at startup"
    echo "               and at 5am each day)"
    exit 0
}

show_update_help() {
    echo "Hardware Design Image Tool $IMAGEVER"
    echo
    echo "hd-image update"
    echo
    echo "Usage: hd-image update [-h|-b BRANCH|-v VERSION]"
    echo "Options:"
    echo "-h            show this help message"
    echo "-b BRANCH     set the branch to update from"
    echo "-v VERSION    override the version number"
    exit 0
}

missing_argument() {
    echo "Missing argument for $1"
    exit 1
}

info() {
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

git_fsck() {
    GITDIRS=`find /home -name .git 2> /dev/null`
    GITCHK=0
    for d in $GITDIRS
    do
        cd $d/..
        echo $d
        if ! /usr/bin/git fsck
        then
            GITCHK=1
        fi
        echo
    done
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
            /usr/bin/logger "Could not connect to internet"
            exit 1
        fi
        sleep 10
        let "tries++"
    done

    if ! [ -z $BRANCH ]
    then
        BRANCH="-C $BRANCH"
    fi

    /usr/local/bin/ansible-pull \
    -U https://gitlab+deploy-token-12:sErpRQP96JzfVponpBh-@stogit.cs.stolaf.edu/hd-image/hd-image.git \
    -e imgVersion=$IMAGEVER $BRANCH

    report | /usr/bin/logger -t PiTracker
}

if test $# -eq 0
then
    show_help
fi    

while test $# -gt 0
do
    case "$1" in
        -h|help)
            show_help
            ;;
        -v|version)
            shift
            echo "Image version is: $IMAGEVER"
            echo
            exit 0
            ;;
        update)
            shift
            while test $# -gt 0
            do
                case "$1" in
                    -h|help)
                        show_update_help
                        ;;
                    -b)
                        shift
                        if test $# -gt 0
                        then
                            BRANCH=$1
                            shift
                        else
                            missing_argument "-b"
                        fi
                        ;;
                    -v)
                        shift
                        if test $# -gt 0
                        then
                            IMAGEVER=$1
                            shift
                        else
                            missing_argument "-v"
                        fi
                        ;;
                    *)
                        show_update_help
                        ;;
                esac
            done
            update
            exit 0
            ;;
        info)
            shift
            info
            exit 0
            ;;
        report)
            shift
            report
            exit 0
            ;;
        git-fsck)
            shift
            git_fsck
            exit $GITCHK
            ;;
        *)
            show_help
            ;;
    esac
    exit 0
done
