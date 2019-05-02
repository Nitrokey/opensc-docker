#!/usr/bin/env bash

if [ "$EUID" != "0" ]; then
    echo "Running script with root privileges"
	exec sudo bash $0 $@
fi

echo
echo ==== Cleaning up unused Docker data
echo

echo ==== Remove earlier versions of opensc images
docker images | grep "opensc" | awk '{print $1}' | xargs docker rm

echo ==== Cleaning up 
docker system prune


