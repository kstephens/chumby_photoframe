
all : images lighty

images :
	./make-images

lighty: lighty/sbin/lighttpd

lighty/sbin/lighttpd : archive/chumby_lighttpd.tar.gz
	mv debugchumby debugchumby.orig
	tar -zxvf $<
	mv debugchumby.orig debugchumby

tarball : all
	tar -xvf ../chumby_photoframe_usb.tar.gz .



