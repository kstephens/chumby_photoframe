
all : images lighty

images :
	./make-images

lighty: lighty/sbin/lighttpd
	tar -zxvf archive/chumby_lighttpd.tar.gz

tarball : all
	tar -xvf ../chumby_photoframe_usb.tar.gz .



