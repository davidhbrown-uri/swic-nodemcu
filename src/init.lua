
function startup()
    if file.open("init.lua") == nil then
        print("init.lua deleted or renamed")
    elseif file.open("application.lua") == nil then
        print("No application.lua to run")
    else
        print("Running")
        file.close("init.lua")
        -- the actual application is stored in 'application.lua'
        dofile("application.lua")
    end
end

print("Startup will run application.lua in 5 seconds...")
tmr.create():alarm(5000, tmr.ALARM_SINGLE, startup)
