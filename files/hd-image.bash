#!/bin/bash

while test $# -gt 0
do
    case "$1" in
        -v|--version)
            cat /usr/share/HD/version
            exit 0
            ;;
        --update)
            /usr/share/HD/pullUpdates.bash
            ;;
        -h|--help|*)
            echo "Hardware Design Image Tool"
            echo
            echo "Options:"
            echo "-h,   --help          show this help message"
            echo "-v,   --version       show the current version of the image"
            echo "      --update        check for image updates"
            echo "                      (this happens automatically at startup"
            echo "                       and at 5am each day)"
            ;;
    esac
done
