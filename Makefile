all: run

.PHONY: setup
setup: build

IMAGE_NAME=nitrokey-opensc-test
DR=docker run -it --rm  --privileged -v /dev:/dev --net=host \
    -v $(shell pwd):/app  \
    $(IMAGE_NAME):latest
CMD=/bin/bash
OPENSC_DIR="opensc-*"

.PHONY: build-opensc
build-opensc:
	# wget -c https://github.com/OpenSC/OpenSC/releases/download/0.19.0/opensc-0.19.0.tar.gz
	# tar xfvz opensc-*.tar.gz
	#	wget -c https://github.com/OpenSC/OpenSC/archive/master.zip
	#	unzip master.zip
	#	mv OpenSC-master opensc-master
	cd "$(OPENSC_DIR)" && ./bootstrap
	cd "$(OPENSC_DIR)" && ./configure --prefix=/usr --sysconfdir=/etc/opensc
	cd "$(OPENSC_DIR)" && make -j4
	cd "$(OPENSC_DIR)" && make install

ARG=
.PHONY: build
build:
	@echo '*** Hint: Add ARG=--pull to update the base image'
	docker build -t $(IMAGE_NAME) . $(ARG)

.PHONY: run
run:
	$(MAKE) run-command-clean CMD="/usr/bin/env make -C /app container-start-default" ARG=$(ARG)

.PHONY: run-command
run-command:
	$(MAKE) run-command-clean CMD="/usr/bin/env make -C /app container-start-shell" ARG=$(ARG)

.PHONY: run-command-clean
run-command-clean:
	-systemctl stop pcscd pcscd.socket
	-killall pcscd scdaemon
	$(DR) $(CMD) $(ARG)

.PHONY: container-start-default
container-start-default:
	pcscd
	sc-hsm-tool

.PHONY: container-start-shell
container-start-shell: | container-start-default
	exec bash

.PHONY: clean
clean:
	docker images | grep $(IMAGE_NAME) | awk '{print $$3}' | xargs docker rmi
	# docker system prune

.PHONY: docker-install-ubuntu
docker-install-ubuntu:
	@echo "*** Warning: this install routine might be outdated"
	@echo "*** See the official Docker installation guide in case of any issues"
	@echo "*** Press ENTER to continue, or CTRL+C to abort"
	@read
	apt-get remove docker docker-engine docker.io
	apt-get install  apt-transport-https  ca-certificates  curl  software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	apt-key fingerprint 0EBFCD88 | tee key.tmp
	grep '9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88' key.tmp && echo -e "\n\n\n\n !!! Repository key seems to be incorrect \n\n\n\n"
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	apt-get update
	apt-get install docker-ce
	docker run hello-world
