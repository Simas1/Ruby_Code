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

#-----------------------------

def called_with_block?
  if block_given?
    puts "Call block"
  end
end

puts called_with_block?.nil? ? "No Block" : "Have Block"
called_with_block? do
  1 + 2
end
