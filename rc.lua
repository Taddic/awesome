-- Standard awesome library
local awful         = require("awful")
local beautiful     = require("beautiful") -- Theme handling library

-- User defined libraries
local autostart     = require("lib.autostart")
local keybindings   = require("lib.keybindings")
local rules         = require("lib.rules")
local standard_cfg  = require("lib.standard_cfg")

-- Widgets
require("widgets.awesome-wm-widgets.battery-widget.battery")       -- Load battery widget
require("widgets.awesome-wm-widgets.brightness-widget.brightness") -- Load brightness widget
require("widgets.awesome-wm-widgets.spotify-widget.spotify")       -- Load spotify widget
require("widgets.awesome-wm-widgets.volume-widget.volume")         -- Load volume widget
require("widgets.network.pech")                                    -- Load network widget

mynetworklauncher = awful.widget.launcher(
   {image = beautiful.awesome_icon,
    menu = awful.menu({items = netmgr.generate_network_menu()})})

standard_cfg.setup({spotify_widget,
		    brightness_widget,
		    volume_widget,
		    battery_widget,
		    mynetworklauncher})

keybindings.setup()

rules.setup({
      {{class = "Chromium-browser"}, {screen = 2, tag = "2"}},
      {{class = "discord"},          {screen = 3, tag = "2"}},
      {{class = "Firefox"},          {screen = 2, tag = "3"}},
      {{class = "Spotify"},          {screen = 1, tag = "1"}},
      {{class = "Thunderbird"},      {screen = 3, tag = "3"}}})


--autostart.applications({"chromium-browser",
--			"discord",
--			"spotify",
--			"thunderbird"})
