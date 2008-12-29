$: = $:.map do | p |
  p.sub("/var/lib/install/usr//", File.expand_path(File.dirname(__FILE__) + '/..') + '/')
end
