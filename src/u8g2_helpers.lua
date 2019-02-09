-- ***************************************************************************
-- USAGE:
--
--  
-- 2. function u8g2draw() ...
-- 3. dofile("u8g2_helpers.lua")
-- 4. u8g2loop_tmp::start()
--
-- ***************************************************************************

-- setup I2c and connect display
function init_i2c_display()
    -- SDA and SCL can be assigned freely to available GPIOs
    local scl = 5 -- GPIO14
    local sda = 6 -- GPIO12
    local sla = 0x3c
    i2c.setup(0, sda, scl, i2c.SLOW)
    u8g2disp = u8g2.ssd1306_i2c_128x64_noname(0, sla)
end

function u8g2_prepare()
  u8g2disp:setFont(u8g2.font_6x10_tf)
  u8g2disp:setFontRefHeightExtendedText()
  u8g2disp:setDrawColor(1)
  u8g2disp:setFontPosTop()
  u8g2disp:setFontDirection(0)
end


function u8g2loop()
  u8g2disp:clearBuffer()
  u8g2draw() -- function to be defined elsewhere
  u8g2disp:sendBuffer()
  -- delay between each frame
  u8g2loop_tmr:start()
end


u8g2_draw_state = 0
u8g2loop_tmr = tmr.create()
u8g2loop_tmr:register(100, tmr.ALARM_SEMI, u8g2loop)

init_i2c_display()

