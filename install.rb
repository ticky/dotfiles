#!/usr/bin/env ruby

# originally from
# from http://errtheblog.com/posts/89-huba-huba

home = File.expand_path(ENV['HOME'])

Dir['*'].each do |file|
  next if file =~ /install/i || file =~ /readme/i || file =~ /bin/i
  target = File.join(home, ".#{file}")
  puts "installing #{File.expand_path file} to #{target}"
  `ln -sf #{File.expand_path file} #{target}`
end
