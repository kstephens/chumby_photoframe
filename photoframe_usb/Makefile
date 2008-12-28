
all : archive

images : media/image-320x240/.created

media/image-320x240/.created : media/image/*
	./make-images
	touch -f $@

lighty: lighty/sbin/lighttpd

lighty/sbin/lighttpd : archive/chumby_lighttpd.tar.gz
	test -e debugchumby.orig || mv debugchumby debugchumby.orig
	tar -zxvf $<
	mv debugchumby.orig debugchumby
	touch -f $@

ARCHIVE=../photoframe_usb.tar.gz

archive : $(ARCHIVE)

$(ARCHIVE) : images lighty
	tar -zcvf $(ARCHIVE) --exclude=archive/ --exclude='media/image/*.*' .

usb=/dev/null
install : archive
	tar -zxvf $(ARCHIVE) -C '$(usb)'

clean:
	rm -f $(ARCHIVE) media/image-320x240/.created

prereqs:
	sudo apt-get install netpbm libjpeg-progs



