-- Standard awesome library
local awful         = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local beautiful     = require("beautiful") -- Theme handling library
local gears         = require("gears")
local wibox         = require("wibox")
require("awful.autofocus")
require("debian.menu")                                             -- Load Debian menu entries
require("widgets.awesome-wm-widgets.battery-widget.battery")       -- Load battery widget
require("widgets.awesome-wm-widgets.brightness-widget.brightness") -- Load brightness widget
require("widgets.awesome-wm-widgets.spotify-widget.spotify")       -- Load spotify widget
require("widgets.awesome-wm-widgets.volume-widget.volume")         -- Load volume widget
require("widgets.network.pech")                                    -- Load network widget

-- User defined libraries
local autostart    = require("autostart")
local keybindings  = require("keybindings")
local myScreen     = require("myScreen")
local rules        = require("rules")
local standard_cfg = require("lib.standard_cfg")

standard_cfg.error_handling()
standard_cfg.theme()
standard_cfg.layouts()


local myawesomemenu = {
   { "hotkeys",     function() return false, hotkeys_popup.show_help end},
   { "manual",      standard_cfg.terminal .. " -e man awesome" },
   { "edit config", standard_cfg.editor_cmd .. " " .. awesome.conffile },
   { "restart",     awesome.restart },
   { "quit",        function() awesome.quit() end}}
local mymainmenu = awful.menu({
      items = {
	 {"awesome",       myawesomemenu, beautiful.awesome_icon},
	 {"Debian",        debian.menu.Debian_menu.Debian},
	 {"open terminal", standard_cfg.terminal}}})

standard_cfg.menu()

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", myScreen.set_wallpaper)

mynetworklauncher = awful.widget.launcher(
   {image = beautiful.awesome_icon,
    menu = awful.menu({items = netmgr.generate_network_menu()})})

myScreen.setup(wibox, {spotify_widget,
		       brightness_widget,
		       volume_widget,
		       battery_widget,
		       mynetworklauncher})

keybindings.mouse(mymainmenu)
keybindings.keyboard(mymainmenu)

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

--autostart.applications({"chromium-browser",
--			"discord",
--			"spotify",
--			"thunderbird"})
