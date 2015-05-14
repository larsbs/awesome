--[[

     Powerarrow Darker Awesome WM config 2.0
     github.com/copycat-killer

--]]

theme                               = {}

themes_dir                          = os.getenv("HOME") .. "/.config/awesome/themes/lars"
theme.wallpaper                     = themes_dir .. "/walls/wall.jpg"

theme.wibox_height                  = 20

theme.primary_color_saturated       = "#C06ED1" --"#8B99CC"
theme.primary_color                 = "#8F459B" --"#474E68"

-- Text
theme.font                          = "Terminus 9"
theme.fg_normal                     = "#DDDDFF"
theme.fg_focus                      = "#FFFFFF"
theme.fg_urgent                     = "#FFFFFF"
theme.bg_normal                     = "#1A1A1A"
theme.bg_focus                      = "#313131"
theme.bg_urgent                     = "#1A1A1A"

-- Borders
theme.border_width                  = "1"
theme.border_normal                 = "#AAAAAA"
theme.border_focus                  = "#C06ED1"
theme.border_marked                 = "#CC9393"

-- Titlebar
theme.titlebar_bg_focus             = "#FFFFFF"
theme.titlebar_bg_normal            = "#FFFFFF"

-- Taglist
theme.taglist_fg_focus              = "#FFFFFF"

-- Tasklist
theme.tasklist_bg_focus             = "#1A1A1A"
theme.tasklist_fg_focus             = "#FFFFFF"

-- Widgets
theme.textbox_widget_margin_top     = 1
theme.notify_fg                     = theme.fg_normal
theme.notify_bg                     = theme.bg_normal
theme.notify_border                 = theme.border_focus
theme.awful_widget_height           = 14
theme.awful_widget_margin_top       = 2
theme.mouse_finder_color            = "#CC9393"
theme.menu_height                   = "20"
theme.menu_width                    = "200"

theme.menu_submenu_icon             = themes_dir .. "/icons/submenu.png"
theme.taglist_squares_sel           = themes_dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel         = themes_dir .. "/icons/square_unsel.png"

theme.layout_tile                   = themes_dir .. "/icons/tile.png"
theme.layout_tilegaps               = themes_dir .. "/icons/tilegaps.png"
theme.layout_tileleft               = themes_dir .. "/icons/tileleft.png"
theme.layout_tilebottom             = themes_dir .. "/icons/tilebottom.png"
theme.layout_tiletop                = themes_dir .. "/icons/tiletop.png"
theme.layout_fairv                  = themes_dir .. "/icons/fairv.png"
theme.layout_fairh                  = themes_dir .. "/icons/fairh.png"
theme.layout_spiral                 = themes_dir .. "/icons/spiral.png"
theme.layout_dwindle                = themes_dir .. "/icons/dwindle.png"
theme.layout_max                    = themes_dir .. "/icons/max.png"
theme.layout_fullscreen             = themes_dir .. "/icons/fullscreen.png"
theme.layout_magnifier              = themes_dir .. "/icons/magnifier.png"
theme.layout_floating               = themes_dir .. "/icons/floating.png"

theme.tasklist_disable_icon         = true
theme.tasklist_floating             = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical   = ""

return theme
