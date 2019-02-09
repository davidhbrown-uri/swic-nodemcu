dofile("util.lua") -- map function

ledPin = 1;
gpio.mode(ledPin,gpio.OUTPUT);
ledOn = false;
ledTimer = tmr.create()
ledRate = 500
ledRateMin = 50
ledRateMax = 1000

adc.force_init_mode(adc.INIT_ADC) -- ensure correct mode
adcChannel=0 -- only 0 on ESP8266
updateTimer = tmr.create()
updateRate=200
cdsRawMin=550
cdsRawMax=920
cdsPercent=50

values = {length=100, current=1} -- to hold readings
for i=1, values.length do
  values[i] = 50
end

function toggleLed()
  ledOn = not ledOn
  gpio.write(ledPin, ledOn and gpio.HIGH or gpio.LOW)
  -- update the interval here, when it has been reached
  ledTimer:interval(ledRate)
end

function readCdsPercent()
--  local range = cdsRawMax - cdsRawMin
--  local raw = adc.read(adcChannel)
--  local base = raw - cdsRawMin
--  cdsPercent = (base * 100) / range
  cdsPercent = map(adc.read(adcChannel), cdsRawMin, cdsRawMax, 0, 100)
  values[values.current]=cdsPercent
  values.current = values.current+1
  if values.current > values.length then values.current = 1 end
--  print("Light Sensor: raw=",raw, "(", cdsPercent, "% )")
end

function setLedRate(percent)
--  local range = ledRateMax - ledRateMin
--  ledRate = (percent * range / 100) + ledRateMin
  ledRate = map(percent, 0, 100, ledRateMin, ledRateMax)
--  print("ledRate: ",ledRate)
end

function update()
  readCdsPercent()
  setLedRate(100-cdsPercent)
  -- don't update the interval here because it will reset.
end

ledTimer:register(ledRate, tmr.ALARM_AUTO, toggleLed)
ledTimer:start()

updateTimer:register(updateRate, tmr.ALARM_AUTO, update)
updateTimer:start()

function u8g2draw()
  for i=1, values.length do
    u8g2disp:drawPixel(i,63-values[i]/4)
  end
  local previous = values.current-1
  if previous < 1 then previous = values.length end
  u8g2disp:drawCircle(previous,63-values[previous]/4,3)
end
dofile("u8g2_helpers.lua")
u8g2loop_tmr:start()
