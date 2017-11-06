require_relative 'debugger_helper'

class Group
  attr_accessor :name, :add_members, :remove_members, :members

  @validation = false

  def initialize(name, add_members = [], remove_members = [], members = [])
    @name, @add_members, @remove_members, @members = name, add_members, remove_members, members

    # return only missing items, case insensitive, and match with end string
    @missing = -> master_list,new_item {
      !master_list.any? { |item| item.match(/#{Regexp.escape(new_item)}$/i) }
    }
    # return only existing items, case insensitive, and match with end string
    @existing = -> master_list,new_item {
      master_list.find_all {|item| item.match(/#{Regexp.escape(new_item)}$/i) }
    }
  end

  def add_members=(groups)
    if groups.respond_to?('each')
      missing_groups(groups)
    else
      missing_groups([groups])
    end
  end

  def remove_members=(groups)
    if groups.respond_to?('each')
      existing_groups(groups)
    else
      existing_groups([groups])
    end
  end

  def members=(groups)
    raise ArgumentError, 'Members should be in array' unless groups.respond_to?('each')

    @validation = true
    # @members = groups.map(&:downcase)
    @members = groups
    missing_groups(@add_members, true)
    existing_groups(@remove_members, true)
  end

  def to_s
    @name
  end

  private

  def missing_groups(check_groups, clear = false)
    @add_members = [] if clear # when members added

    # remove duplicates, add groups which not exist in add_members
    add = check_groups.find_all(&@missing.curry[@add_members])

    # add groups which not exist in members
    add = add.find_all(&@missing.curry[@members])

    # add differences
    clear ? @add_members = add : @add_members.concat(add)
  end

  def existing_groups(check_groups, clear = false)
    @remove_members = [] if clear # when members added

    # remove duplicates, add groups which not exist in remove_members
    remove = check_groups.find_all(&@missing.curry[@remove_members])

    # add groups which exist in members, replace with members values
    remove = @validation ? remove.map(&@existing.curry[@members]).flatten : remove

    # add differences
    clear ? @remove_members = remove : @remove_members.concat(remove)
  end
end

class Groups
  include Enumerable

  def initialize(*groups_list)
    @groups = [] # default value
    groups_list.each do |group|
      self.add = group
    end
  end

  # enumerable required
  def each(&block)
    @groups.each do |group|
      block.call(group)
    end
  end

  def each_empty_skip(&block)
    filter = @groups.find_all {|group| !group.add_members.empty? || !group.remove_members.empty?}
    filter.each do |group|
      block.call(group)
    end
  end

  def add=(new_group)
    not_exist = true
    # check if already exist such group
    @groups.map! do |group|
      if group.name.downcase == new_group.name.downcase # append existing group
        not_exist = false
        # merge
        group.members = new_group.members unless new_group.members.empty? # add members unless is not empty
        group.add_members = new_group.add_members
        group.remove_members = new_group.remove_members
        group
      else # no changes
        group
      end
    end

    # new group
    @groups.push(new_group) if not_exist
  end
end

#---------------------------------
bla = Group.new('Crap')
bla.add_members = 'Group'
bla.add_members = ['Group1','Group2']
bla.members = ['Client\Group', 'Local\Group3']

bla.remove_members = 'Group'
bla.remove_members = ['Group','Group4','gRoUp3']

bla.add_members = ['GrOup1','GrouP3']

bla2 = Group.new('Crap2')
bla2.add_members = 'Group'
bla2.add_members = ['Group1','Group2']
bla2.members = ['Group', 'Group3']

bla3 = Group.new('Crap3')
bla3.members = ['Group', 'Group3']

puts bla.inspect

#---------------------------------
col = Groups.new(bla,bla2)
col.add = bla
col.add = bla3

puts col.inspect

col.each {|group| puts group.name}

col2 = Groups.new()
col2.each {|group| puts group.name}

puts "Without empty:"
col.each_empty_skip{|group| puts group.name}



