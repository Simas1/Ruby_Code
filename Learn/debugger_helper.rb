at_exit do
  sleep(1) # cheap way to fix ECONNRESET in debugger
end
