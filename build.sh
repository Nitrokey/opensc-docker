
all:
	# wget -c https://github.com/OpenSC/OpenSC/releases/download/0.19.0/opensc-0.19.0.tar.gz
	# tar xfvz opensc-*.tar.gz
	wget -c https://github.com/OpenSC/OpenSC/archive/master.zip
	unzip master.zip
	mv OpenSC-master opensc-master
	#cd opensc-*
	cd opensc-* && ./bootstrap
	cd opensc-* && ./configure --prefix=/usr --sysconfdir=/etc/opensc
	cd opensc-* && make -j4
	cd opensc-* && make install

