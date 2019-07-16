#!/bin/bash

show_help() {
    echo "Hardware Design Image Tool"
    echo
    echo "Options:"
    echo "-h,   --help          show this help message"
    echo "-v,   --version       show the current version of the image"
    echo "      --update        check for image updates"
    echo "                      (this happens automatically at startup"
    echo "                       and at 5am each day)"
    exit 1
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
            /usr/share/HD/pullUpdates.bash
            ;;
        *)
            show_help
            ;;
    esac
    exit 0
done

show_help
