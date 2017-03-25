require_relative 'debugger_helper'

def source(name)
  puts "Using source from #{name}"
end

def path(path)
  puts "Using path from #{path}"
end

def template(name, &block)
  puts "Create template #{name}"
  block.call
end


template 'C:\temp\test.txt' do
  source 'Source.txt'
  path 'www.empty.com'
end