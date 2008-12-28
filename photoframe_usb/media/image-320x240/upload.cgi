#!/usr/bin/env ruby
# -*- ruby -*-

dst_dir = File.expand_path(".")

begin
  puts "Content-Type: text/plain"
  puts

  # ruby script fragment
  require 'cgi'
  # require 'stringio' # not in 1.8.4?

  cgi = CGI.new()  # New CGI object

  file = cgi.params['file']
  raise ArgumentError, "file not set" unless file

  # get uri of tx'd file (in tmp normally)
  tmpfile = file.first.path

  # create a Tempfile reference
  fromfile = file.first
  
  puts "original_filename = #{fromfile.original_filename.inspect}"
  puts "content_type = #{fromfile.content_type.chomp.inspect}"
  
  dst_file = "#{dst_dir}/#{fromfile.original_filename}"
 
  raise ArgumentError, "bad filename" unless dst_file =~ /\.(jpg|png)$/i;

  # note the untaint prevents a security error
  dst_file = dst_file.untaint

  # copy the file
  # cgi sets up an StringIO object if file < 10240
  # or a Tempfile object following works for both
  File.open(dst_file, 'w') { |file| file << fromfile.read }
  # when the page finishes the Tempfile/StringIO!) thing is deleted automatically
  
  puts "dst_file = #{dst_file.inspect}"
  puts "file_size = #{File.size(dst_file).inspect}"

  system("/mnt/usb/bin/make-images")
rescue Exception => err
  puts "<pre>"
  puts "ERROR: #{err.inspect}"
  puts "  #{err.backtrace * "\n  "}"
  puts "</pre>"
end
exit 0


