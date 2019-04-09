function doName(data)
  print("hello", data)
end

practice = function (str)
  if str == "hello" then
    print("world")

  elseif str == "name" then
    print("what is your name?")
    -- name=io.read()
    -- print("hello", name)
    uart.on("data", "\r", doName, 0)

  else
    print("no options")
  end
end

