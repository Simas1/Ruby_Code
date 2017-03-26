require_relative 'debugger_helper'

#Proc
discount = Proc.new do |price|
  price - (price * 0.15)
end
tax = Proc.new do |price|
  price + (price * 0.21)
end

puts 'Call Proc'
puts discount.call(100)

# this is for demonstration, map already exist in Enumerables
def map(list, fn) #fn -function
  results = []
  list.each do |item|
    results << fn.call(item)
  end
  results
end

price_list = [100, 80, 20]
puts 'Call Map'
puts map(price_list, discount) # pass Proc as parameter
puts map(price_list, tax)

puts 'Already exist map in enumerable'
puts price_list.map(&discount) # pass Proc as Block

puts 'How it works:'
result = price_list.map do |price|
  price - (price * 0.15)
end
puts result.join(',')

result = price_list.map {|price| price - (price * 0.15)}
puts result.join(',')

