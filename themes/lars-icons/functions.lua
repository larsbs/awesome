local gears             = require("gears")
local awful             = require("awful")
local awful_rules       = require("awful.rules")
local awful_autofocus   = require("awful.autofocus")
local wibox             = require("wibox")
local beautiful         = require("beautiful")
local naughty           = require("naughty")
local drop              = require("scratchdrop")
local lain              = require("lain")


local Functions = {}

-- beautiful init
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/lars-icons/theme.lua")

-- Error signal
Functions.error_signal = function (err)
    if in_error then return end
    in_error = true
    error_notification = {
        preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
        text = err
    }
    naughty.notify(error_notification)
    in_error = false
end

-- Run once
Functions.run_once = function (cmd)
    findme = cmd
    firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace-1)
    end
    awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

-- Minimize a client if it's maximized and viceversa
Functions.minimize_maximize_toggle = function (c)
    if c == client.focus then
        c.minimized = true
    else
        -- Without this, the following
        -- :isvisible() makes no sense
        c.minimized = false
        if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
        end
        -- This will also un-minimize
        -- the client, if needed
        client.focus = c
        c:raise()
    end
end

-- Shows a small dropdown that list all the clients
-- in the tasklist of every screen
Functions.show_all_clients_dropdown = function ()
    if instance then
        instance:hide()
        instance = nil
    else
        instance = awful.menu.clients({ width=250 })
    end
end

-- Previous layout
Functions.previous_layout = function (layouts)
    awful.layout.inc(layouts, -1)
end

-- Next layout
Functions.next_layout = function (layouts)
    awful.layout.inc(layouts, 1)
end

-- Shows the main menu of awesome
Functions.show_main_menu = function ()
    mymainmenu:toggle()
end

Functions.show_main_menu_k = function ()
    mymainmenu:toggle({ keygrabber = true })
end

-- Take screenshot
-- This function is based in "scripts/screenshot.sh"
Functions.take_screenshot = function ()
    os.execute("screenshot")
end

-- Go to previous client by id
Functions.previous_client = function ()
    awful.client.focus.byidx(-1)
    if client.focus then
        client.focus:raise()
    end
end

-- Go to next client by id
Functions.next_client = function ()
    awful.client.focus.byidx(1)
    if client.focus then
        client.focus:raise()
    end
end

-- Go to client to the bottom
Functions.bottom_client = function ()
    awful.client.focus.bydirection("down")
    if client.focus then
        client.focus:raise()
    end
end

-- Go to client to the top
Functions.top_client = function ()
    awful.client.focus.bydirection("up")
    if client.focus then
        client.focus:raise()
    end
end

-- Go to client to the left
Functions.left_client = function ()
    awful.client.focus.bydirection("left")
    if client.focus then
        client.focus:raise()
    end
end

-- Go to client to the right
Functions.right_client = function ()
    awful.client.focus.bydirection("right")
    if client.focus then
        client.focus:raise()
    end
end

-- Toggle clients
Functions.toggle_client = function ()
    awful.client.focus.history.previous()
    if client.focus then
        client.focus:raise()
    end
end

-- Focus next screen
Functions.next_screen = function ()
    awful.screen.focus_relative(1)
end

-- Focus previous screen
Functions.previous_screen = function ()
    awful.screen.focus_relative(-1)
end

-- Toggle hide wibox
Functions.toggle_hide_wibox = function ()
    mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
end


-- VOLUME

-- Raise volume
Functions.raise_volume = function ()
    awful.util.spawn("amixer -q set Master 1%+")
    volwidget.update()
end

-- Lower volume
Functions.lower_volume = function ()
    awful.util.spawn("amixer -q set Master 1%-")
    volwidget.update()
end

-- Mute volume
Functions.mute_volume = function ()
    awful.util.spawn("amixer -q set Master playback toggle")
    volwidget.update()
end

-- Max volume
Functions.max_volume = function ()
    awful.util.spawn("amixer -q set Master playback 100%")
    volwidget.update()
end


-- CLIENT KEYS

-- Toggle client full screen
Functions.toggle_full_screen = function (c)
    c.fullscreen = not c.fullscreen
end

-- Minimize client
Functions.minimize_client = function (c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    c.minimized = true
end

-- Maximize client
Functions.maximize_client = function (c)
    c.maximized_horizontal = not c.maximized_horizontal
    c.maximized_vertical   = not c.maximized_vertical
end

return Functions
