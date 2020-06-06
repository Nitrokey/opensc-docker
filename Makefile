
DIR="opensc-*"

all:
	# wget -c https://github.com/OpenSC/OpenSC/releases/download/0.19.0/opensc-0.19.0.tar.gz
	# tar xfvz opensc-*.tar.gz
#	wget -c https://github.com/OpenSC/OpenSC/archive/master.zip
#	unzip master.zip
#	mv OpenSC-master opensc-master
	cd "$(DIR)" && ./bootstrap
	cd "$(DIR)" && ./configure --prefix=/usr --sysconfdir=/etc/opensc
	cd "$(DIR)" && make -j4
	cd "$(DIR)" && make install

