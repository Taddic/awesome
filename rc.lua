local awful         = require("awful")     -- Standard awesome library
local hotkeys_popup = require("awful.hotkeys_popup").widget
local beautiful     = require("beautiful") -- Theme handling library
local gears         = require("gears")     -- Standard awesome library
local naughty       = require("naughty")   -- Notification library
local wibox         = require("wibox")     -- Widget and layout library

require("awful.autofocus")

require("debian.menu")                                             -- Load Debian menu entries
require("widgets.awesome-wm-widgets.spotify-widget.spotify")       -- Load spotify widget
require("widgets.awesome-wm-widgets.brightness-widget.brightness") -- Load brightness widget
require("widgets.awesome-wm-widgets.volume-widget.volume")         -- Load volume widget
require("widgets.awesome-wm-widgets.battery-widget.battery")       -- Load battery widget
require("widgets.network.pech")                                    -- Load network widget

local standard_cfg = require("lib.standard_cfg")
local myScreen     = require("myScreen")
local keybindings  = require("keybindings")
local rules        = require("rules")
local autostart    = require("autostart")

standard_cfg.error_handling()
standard_cfg.theme()
standard_cfg.layouts()
standard_cfg.menu()


-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", myScreen.set_wallpaper)

-- create a network menu widget
function mynetworkmenu()
   networkmenu = awful.menu({	items = netmgr.generate_network_menu()	  })
   return networkmenu
end
mynetworklauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
					    menu = mynetworkmenu()})

myScreen.setup(wibox, {spotify_widget,
		       brightness_widget,
		       volume_widget,
		       battery_widget,
		       mynetworklauncher}, standard_cfg.mylauncher)

keybindings.mouse(standard_cfg.mymainmenu)
keybindings.keyboard(standard_cfg.mymainmenu, standard_cfg.terminal)

rules.setup({
      {{class = "Chromium-browser"}, {screen = 2, tag = "2"}},
      {{class = "discord"},          {screen = 3, tag = "2"}},
      {{class = "Firefox"},          {screen = 2, tag = "3"}},
      {{class = "Spotify"},          {screen = 1, tag = "1"}},
      {{class = "Thunderbird"},      {screen = 3, tag = "3"}}})

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

autostart.applications({"chromium-browser",
			"discord",
			"spotify",
			"thunderbird"})
