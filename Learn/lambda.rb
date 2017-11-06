add = ['a','B','c','F']
add_members = ['b','c']



result = add.find_all do |group|
  !add_members.any? { |val| val.match(/#{group}$/i) } # case insensitive, and match with end string
end

puts result.inspect


existing = ->  new_list,master_list {
  new_list.find_all do |new_item|
    !master_list.any? { |item| item.match(/#{new_item}$/i) }
  end
}
result2 = existing[add,add_members]
puts result2.inspect

not_exist_in_add_members = -> item do
  !add_members.any? { |member| member.match(/#{item}$/i) }
end
result3 = add.find_all(&not_exist_in_add_members)
puts result3.inspect

# --------------------
# return only existing items, case insensitive, and match with end string
# existing = -> master_list,new_item {
#   !master_list.any? { |item| item.match(/#{new_item}$/i) }
# }
existing = Proc.new { |master_list,new_item|
  !master_list.any? { |item| item.match(/#{new_item}$/i) }
}
# add master list
existing_add_members = existing.curry[add_members]


result4 = add.find_all(&existing_add_members)
puts result4.inspect

# puts exist['a',add_members]

