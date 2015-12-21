local gears             = require("gears")
local awful             = require("awful")
local awful_rules       = require("awful.rules")
local awful_autofocus   = require("awful.autofocus")
local wibox             = require("wibox")
local beautiful         = require("beautiful")
local naughty           = require("naughty")
local drop              = require("scratchdrop")
local lain              = require("lain")


-- beautiful init
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/lars-icons/theme.lua")


local Widgets = {}

local primary_color_saturated = beautiful.primary_color_saturated
local primary_color = beautiful.primary_color

-- TEXTCLOCK
weekday = lain.util.markup(primary_color_saturated, " %a")
monthday = " %d"
monthname = lain.util.markup(primary_color_saturated, " %b")
time = " %H:%M "
year = lain.util.markup("")
Widgets.textclock = awful.widget.textclock(weekday .. monthday .. monthname .. time)

-- MEM
function mem_settings_function()
    widget:set_text(mem_now.used .. "MB ")
end
Widgets.mem = lain.widgets.mem({ settings = mem_settings_function })
Widgets.mem.icon = wibox.widget.imagebox(beautiful.mem_icon)

-- CPU
function cpu_settings_function()
    widget:set_text(cpu_now.usage .. "% ")
end
Widgets.cpu = lain.widgets.cpu({ settings = cpu_settings_function })
Widgets.cpu.icon = wibox.widget.imagebox(beautiful.cpu_icon)

-- VOLUME
volicon = wibox.widget.imagebox(beautiful.vol_icon)
function volume_settings_function()
    if volume_now.status == "off" then
        volicon:set_image(beautiful.vol_mute_icon)
    elseif tonumber(volume_now.level) == 0 then
        volicon:set_image(beautiful.vol_no_icon)
    elseif tonumber(volume_now.level) <= 50 then
        volicon:set_image(beautiful.vol_low_icon)
    else
        volicon:set_image(beautiful.vol_icon)
    end

    widget:set_text(volume_now.level)
end
Widgets.vol = lain.widgets.alsa({ settings = volume_settings_function })
Widgets.vol.icon = volicon

-- BATTERY
function battery_settings_function()
    header = " Bat "
    bat_percent = bat_now.perc

    if bat_percent == "N/A" then
        bat_percent = "Plug"
    end

    widget:set_markup(lain.util.markup(primary_color_saturated, header) .. bat_percent .. " ")
end
Widgets.bat = lain.widgets.bat({ settings = battery_settings_function })

-- NETWORK
function network_settings_function()
    header = " Net "
    net = "Off"

    if net_now.state == "up" then
        net = net_now.received .. " - " .. net_now.sent
    end

    widget:set_text(net .. " ")
end
Widgets.net = lain.widgets.net({ settings = network_settings_function })
Widgets.net.icon = wibox.widget.imagebox(beautiful.net_icon)


return Widgets
