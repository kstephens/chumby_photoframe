
all : archive

images : media/image-320x240/.created

media/image-320x240/.created : media/image/*
	bin/make-images
	touch -f $@

lighttpd: lighty/sbin/lighttpd

lighty/sbin/lighttpd : archive/chumby_lighttpd.tar.gz
	test -e debugchumby.orig || mv debugchumby debugchumby.orig
	tar -zxvf $<
	mv debugchumby.orig debugchumby
	touch -f $@

ruby: ruby_arm/bin/ruby

ruby_arm/bin/ruby : archive/chumby_ruby.tgz
	tar -zxvf $<
	rm -f ruby irb erb
	touch -f $@

ARCHIVE=../photoframe_usb.tar.gz

archive : $(ARCHIVE)

$(ARCHIVE) : images lighttpd ruby
	tar -zcvf $(ARCHIVE) --exclude=archive/ --exclude='media/image/*.*' .

usb=/dev/null
install : archive
	tar -zxvf $(ARCHIVE) -C '$(usb)'

clean:
	rm -f $(ARCHIVE) media/image-320x240/.created

prereqs:
	sudo apt-get install netpbm libjpeg-progs

ip=10.1.0.106
sync_files=\
  bin/make-images \
  debugchumby.* \
  lighttpd.conf \
  media/image-*/*.cgi \
  media/image-*/*.html \

sync_to_chumby:
	set -e; for f in `ls $(sync_files)` ; do \
	  scp -p $$f root@$(ip):/mnt/usb/$$f ;\
	done
	ssh root@$(ip) 'cd /mnt/usb && ./debugchumby'





