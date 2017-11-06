require_relative 'debugger_helper'

# https://mixandgo.com/blog/mastering-ruby-blocks-in-less-than-5-minutes
# http://nsomar.com/untiabout-ruby-selftled/

class Win
  class Event
    def initialize
      @service_url = 'host:666'
    end

    def self.send(&block)
      if block_given?
        # only if parametrs are passed
        event = self.new
        evaluation_result = event.instance_eval(&block)
        event.post
      else
        puts "Log: missing parameters"
      end
    end

    def post
      puts "Send data! Name: #{@name} LastName: #{@lastname} URL: #{@service_url}"
    end

    private

    def name(name)
      @name = name
    end

    def lastname(lastname)
      @lastname = lastname
    end

  end
end

Win::Event.send do
  name "Simonas"
  lastname "Striupkus"
end

