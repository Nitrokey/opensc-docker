
all:
	wget -c https://github.com/OpenSC/OpenSC/releases/download/0.19.0/opensc-0.19.0.tar.gz
	tar xfvz opensc-*.tar.gz
	#cd opensc-*
	cd opensc-* && ./bootstrap
	cd opensc-* && ./configure --prefix=/usr --sysconfdir=/etc/opensc
	cd opensc-* && make
	cd opensc-* && make install

