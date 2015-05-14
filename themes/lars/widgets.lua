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
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/lars/theme.lua")


local Widgets = {}

local primary_color_saturated = "#C06ED1"
local primary_color = "#8F459B"

-- TEXTCLOCK
weekday = lain.util.markup(primary_color_saturated, " %a")
monthday = " %d"
monthname = lain.util.markup(primary_color_saturated, " %b")
time = " %H:%M "
year = lain.util.markup("")
Widgets.textclock = awful.widget.textclock(weekday .. monthday .. monthname .. time)

-- MEM
function mem_settings_function()
    widget:set_markup(lain.util.markup(primary_color_saturated, " Mem ") .. mem_now.used .. "MB ")
end
Widgets.mem = lain.widgets.mem({ settings = mem_settings_function })

-- CPU
function cpu_settings_function()
    widget:set_markup(lain.util.markup(primary_color_saturated, " CPU ") .. cpu_now.usage .. "% ")
end
Widgets.cpu = lain.widgets.cpu({ settings = cpu_settings_function })

-- VOLUME
function volume_settings_function()
    header = " Vol "
    vlevel = volume_now.level

    if volume_now.status == "off" then
        vlevel = vlevel .. "M "
    else
        vlevel = vlevel .. " "
    end

    widget:set_markup(lain.util.markup(primary_color_saturated, header) .. vlevel)
end
Widgets.volume = lain.widgets.alsa({ settings = volume_settings_function })

-- BATTERY
function battery_settings_function()
    header = " Bat "
    bat_percent = bat_now.perc

    if bat_percent == "N/A" then
        bat_percent = "Plug"
    end

    widget:set_markup(lain.util.markup(primary_color_saturated, header) .. bat_percent .. " ")
end
Widgets.battery = lain.widgets.bat({ settings = battery_settings_function })

-- NETWORK
function network_settings_function()
    header = " Net "
    net = "Off"

    if net_now.state == "up" then
        net = net_now.received .. " - " .. net_now.sent
    end

    widget:set_markup(lain.util.markup(primary_color_saturated, header) .. net .. " ")
end
Widgets.net = lain.widgets.net({ settings = network_settings_function })


return Widgets
