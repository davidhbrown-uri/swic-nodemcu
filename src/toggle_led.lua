-- possibly our second example after blink?

LED = 1
gpio.mode(LED, gpio.OUTPUT)
gpio.write(LED, gpio.LOW)
ledOn = false

SWITCH = 3
gpio.mode(SWITCH, gpio.INPUT, gpio.PULLUP)
--use the internal weak pull-up resistor so we can simply
--connect the GPIO pin to ground without additional parts.

debounceTmr=tmr.create()

function toggleLed()
  ledOn = not ledOn
  gpio.write(LED, ledOn and gpio.HIGH or gpio.LOW)
end

function pressed(level, when, eventcount)
-- without any debouncing:
--  gpio.trig(SWITCH, "up", released)
-- software debouncing:
  debounceTmr:register(20, tmr.ALARM_SINGLE, 
  function()
    if(gpio.read(SWITCH)==level) then 
      gpio.trig(SWITCH, "up", released)
    end
  end  
  )
  debounceTmr:start()
end


function released(level, when, eventcount)
-- no debounce:
--  toggleLed()
--  gpio.trig(SWITCH, "down", pressed)
  debounceTmr:register(20, tmr.ALARM_SINGLE, 
  function()
    if(gpio.read(SWITCH)==level) then 
      toggleLed()
      gpio.trig(SWITCH, "down", pressed)
    end
  end  
  )
  debounceTmr:start()
end

function printswitch()
  print(gpio.read(SWITCH))
end

gpio.trig(SWITCH, "down", pressed)

-- debugTmr = tmr.create()
-- debugTmr:register(500, tmr.ALARM_AUTO, printswitch)
-- debugTmr:start()
