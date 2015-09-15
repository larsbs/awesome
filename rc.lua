-- REQUIRED LIBRARIES
local gears             = require("gears")
local awful             = require("awful")
local awful_rules       = require("awful.rules")
local awful_autofocus   = require("awful.autofocus")
local wibox             = require("wibox")
local beautiful         = require("beautiful")
local naughty           = require("naughty")
local drop              = require("scratchdrop")
local lain              = require("lain")
local widgets           = require("themes/lars-icons/widgets")
local fn                = require("themes/lars-icons/functions")


-- ERROR HANDLING
if awesome.startup_errors then
    error_notification = {
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    }
    naughty.notify(error_notification)
end

do
    local in_error = false
    awesome.connect_signal("debug::error", fn.error_signal)
end


-- AUTOSTART APPLICATIONS
fn.run_once("urxvtd")
fn.run_once("unclutter")
fn.run_once("compton")
fn.run_once("xrandr --output VGA1 --mode 1440x900 --right-of LVDS1")
fn.run_once("numlockx on")


-- VARIABLE DEFINITIONS

-- localization
-- os.setlocale(os.getenv("LANG"))

-- beautiful init
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/lars-icons/theme.lua")

-- wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, false)
    end
end

-- common
modkey     = "Mod4"
altkey     = "Mod1"
terminal   = "urxvtc" or "xterm"
editor     = os.getenv("EDITOR") or "nano" or "vi"
editor_cmd = terminal .. " -e " .. editor

-- user defined
browser    = "dwb"
browser2   = "iron"
gui_editor = "gvim"
graphics   = "gimp"
mail       = terminal .. " -e mutt "
iptraf     = terminal .. " -g 180x54-20+34 -e sudo iptraf-ng -i all "
musicplr   = terminal .. " -g 130x34-320+16 -e ncmpcpp "

local layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.max,
}


-- TAGS
tags = {
    names = { " 1 ", " 2 ", " 3 ", " 4 ", " 5 "},
    layout = { layouts[1], layouts[1], layouts[1], layouts[1], layouts[1] }
}

for s = 1, screen.count() do
    tags[s] = awful.tag(tags.names, s, tags.layout)
end


-- MENU
require("freedesktop/freedesktop")


-- WIDGETS

-- textclock
textclock = widgets.textclock
-- attach calendar widget to clock:hover
lain.widgets.calendar:attach(textclock, { font_size = 10 })

-- MEM
memwidget = widgets.mem
memicon = widgets.mem.icon

-- CPU
cpuwidget = widgets.cpu

-- Volume
volumewidget = widgets.vol

-- Battery
batterywidget = widgets.battery

-- Network
netwidget = widgets.net

-- Separators
spr = wibox.widget.textbox(" ")


-- CREATE A WIBOX FOR EACH SCREEN AND ADD IT

-- Init wibox and wibox widgets
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytasklist = {}

-- Set mouse buttons (1 = First button, 3 = Second button)
mytaglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly), -- First button click
    awful.button({ modkey }, 1, awful.client.movetotag), -- First button mod click
    awful.button({ }, 3, awful.tag.viewtoggle), -- Second button click
    awful.button({ modkey }, 3, awful.client.toggletag), -- Second button first click
    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)

-- Set tasklist mouse actions
mytasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, fn.minimize_maximize_toggle),
    awful.button({ }, 3, fn.show_all_clients_dropdown)
)

-- Set layoutbox mouse actions
mylayoutbox.buttons = awful.util.table.join(
    awful.button({ }, 1, fn.next_layout), -- Click moves to the next layout
    awful.button({ }, 3, fn.previous_layout) -- Click moves back to the previous layout
)

-- Iterate through screens and add corresponding widgets
for s = 1, screen.count() do

    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()

    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(mylayoutbox.buttons)

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position="top", screen=s, height=beautiful.wibox_height })

    -- Widgets that are aligned to the upper left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(spr)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])
    left_layout:add(spr)

    -- Widgets that are aligned to the upper right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then
        right_layout:add(wibox.widget.systray())
    end
    right_layout:add(widgets.mem.icon)
    right_layout:add(widgets.mem)
    right_layout:add(widgets.cpu.icon)
    right_layout:add(widgets.cpu)
    right_layout:add(widgets.net.icon)
    right_layout:add(widgets.net)
    right_layout:add(widgets.vol.icon)
    right_layout:add(widgets.vol)
    right_layout:add(textclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)
    mywibox[s]:set_widget(layout)

end


-- MOUSE BINDINGS
root.buttons(awful.util.table.join(
    awful.button({ }, 3, fn.show_main_menu),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

clientbuttons = awful.util.table.join(
    awful.button({        }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- KEY BINDINGS
globalkeys = awful.util.table.join(
    -- Take a screenshot
    awful.key({ altkey }, "p", fn.take_screenshot),

    -- Tag browsing
    awful.key({ modkey }, "Left",   awful.tag.viewprev),
    awful.key({ modkey }, "Right",  awful.tag.viewnext),
    awful.key({ modkey }, "Escape", awful.tag.history.restore),

    -- Non-empty tag browsing
    awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end),
    awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end),

    -- Default client focus
    awful.key({ altkey }, "k", fn.next_client),
    awful.key({ altkey }, "j", fn.previous_client),

    -- By direction client focus
    awful.key({ modkey }, "j", fn.bottom_client),
    awful.key({ modkey }, "k", fn.top_client),
    awful.key({ modkey }, "h", fn.left_client),
    awful.key({ modkey }, "l", fn.right_client),

    -- Show Menu
    awful.key({ modkey }, "w", fn.show_main_menu_k),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", fn.toggle_hide_wibox),

    -- Layout manipulation
    awful.key({ modkey, "Control" }, "k",       fn.next_screen),
    awful.key({ modkey, "Control" }, "j",       fn.previous_screen),
    awful.key({ modkey,           }, "u",       awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",     fn.toggle_client),
    awful.key({ modkey,           }, "space",   function () fn.next_layout(layouts) end),
    awful.key({ modkey, "Shift"   }, "space",   function () fn.previous_layout(layouts) end),
    awful.key({ modkey, "Control" }, "n",       awful.client.restore),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r",      awesome.restart),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit),

    -- Dropdown terminal
    awful.key({ modkey,           }, "z", function () drop(terminal) end),

    -- Widgets popups
    awful.key({ altkey,           }, "c", function () lain.widgets.calendar:show(7) end),

    -- ALSA volume control
    awful.key({ altkey            }, "Up",      fn.raise_volume),
    awful.key({ altkey            }, "Down",    fn.lower_volume),
    awful.key({ altkey            }, "m",       fn.mute_volume),
    awful.key({ altkey, "Control" }, "m",       fn.max_volume),

    -- Copy to clipboard
    awful.key({ modkey }, "c", function () os.execute("xsel -p -o | xsel -i -b") end),

    -- User programs
    awful.key({ modkey }, "q", function () awful.util.spawn(browser) end),

    -- Prompt
    awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),

    -- Lock screen
    awful.key({ modkey, "Control" }, "l", function () os.execute("dm-tool switch-to-greeter") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      fn.toggle_full_screen),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill() end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop end),
    awful.key({ modkey,           }, "n",      fn.minimize_client),
    awful.key({ modkey,           }, "m",      fn.maximize_client)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(
        globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
            function ()
                local tag = awful.tag.gettags(mouse.screen)[i]
                if tag then
                    awful.tag.viewonly(tag)
                end
            end
        ),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function ()
                local tag = awful.tag.gettags(mouse.screen)[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end
        ),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function ()
                local tag = awful.tag.gettags(client.focus.screen)[i]
                if client.focus and tag then
                    awful.client.movetotag(tag)
                end
            end
        )
    )
end

-- Set keys
root.keys(globalkeys)


-- RULES
awful_rules.rules = {
    {
        rule = { }, -- All clients will match this rule.
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            keys = clientkeys,
            buttons = clientbuttons,
            size_hints_honor = false
        }
    },
    {
        rule = { class = "Synapse" },
        properties = {
            border_width = 0
        }
    },
    {
        rule = { class = "URxvt" },
        properties = {
            opacity = 0.99
        }
    },
    {
        rule = { class = "MPlayer" },
        properties = {
            floating = true
        }
    },
    {
        rule = { class = "Dwb" },
        properties = { }
    },
    {
        rule = { instance = "plugin-container" },
        properties = {
            tag = tags[1][1] }
        },
    {
        rule = { class = "Gimp" },
        properties = { }
    },
    {
        rule = { class = "Gvim" },
        properties = {
            size_hints_honor = false
        }
    },
    {
        rule = { class = "Gimp", role = "gimp-image-window" },
        properties = {
            maximized_horizontal = true,
            maximized_vertical = true
        }
    },
}


-- SIGNALS

-- signal function to execute when a new client appears.
client.connect_signal("manage",
    function (c, startup)
        -- enable sloppy focus
        c:connect_signal("mouse::enter",
            function(c)
                if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                    and awful.client.focus.filter(c) then
                    client.focus = c
                end
            end
        )

        if not startup and not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end

        local titlebars_enabled = false
        if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
            -- buttons for the titlebar
            local buttons = awful.util.table.join(
                awful.button({ }, 1,
                    function()
                        client.focus = c
                        c:raise()
                        awful.mouse.client.move(c)
                    end
                ),
                awful.button({ }, 3,
                    function()
                        client.focus = c
                        c:raise()
                        awful.mouse.client.resize(c)
                    end
                )
            )

            -- widgets that are aligned to the right
            local right_layout = wibox.layout.fixed.horizontal()
            right_layout:add(awful.titlebar.widget.floatingbutton(c))
            right_layout:add(awful.titlebar.widget.maximizedbutton(c))
            right_layout:add(awful.titlebar.widget.stickybutton(c))
            right_layout:add(awful.titlebar.widget.ontopbutton(c))
            right_layout:add(awful.titlebar.widget.closebutton(c))

            -- the title goes in the middle
            local middle_layout = wibox.layout.flex.horizontal()
            local title = awful.titlebar.widget.titlewidget(c)
            title:set_align("center")
            middle_layout:add(title)
            middle_layout:buttons(buttons)

            -- now bring it all together
            local layout = wibox.layout.align.horizontal()
            layout:set_right(right_layout)
            layout:set_middle(middle_layout)

            awful.titlebar(c, { size=16 }):set_widget(layout)
        end
    end
)

-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_color = beautiful.border_normal
        else
            c.border_color = beautiful.border_focus
        end
    end
)
client.connect_signal("unfocus",
    function(c)
        c.border_color = beautiful.border_normal
    end
)

-- Arrange signal handler
for s = 1, screen.count() do
    screen[s]:connect_signal("arrange",
        function ()
            local clients = awful.client.visible(s)
            local layout  = awful.layout.getname(awful.layout.get(s))

            if #clients > 0 then -- Fine grained borders and floaters control
                for _, c in pairs(clients) do -- Floaters always have borders
                    if awful.client.floating.get(c) or layout == "floating" then
                        c.border_width = beautiful.border_width
                    elseif #clients == 1 or layout == "max" then
                        -- No borders with only one visible client
                        clients[1].border_width = 0
                    else
                        c.border_width = beautiful.border_width
                    end
                end
            end
        end
    )
end
