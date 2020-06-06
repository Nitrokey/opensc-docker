#!/usr/bin/env bash

if [ "$EUID" != "0" ]; then
    echo "Running script with root privileges"
	exec sudo bash $0 $@
fi

echo === Closing working pcscd on host
systemctl stop pcscd pcscd.socket
killall pcscd scdaemon

DR="docker run -it  --privileged -v /dev:/dev --net=host \
    -v ${PWD}:/app  \
    opensc:latest"
if [ -z "$1" ]; then
    # no arguments - run shell
    ${DR} /bin/bash
else
    # run command and exit on completion
    ${DR} $@
fi
