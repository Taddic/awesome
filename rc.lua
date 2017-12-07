--------------------------------------------------------------------------------
-- User defined libraries                                                     --
--------------------------------------------------------------------------------
local autostart     = require("lib.autostart")
local keybindings   = require("lib.keybindings")
local rules         = require("lib.rules")
local standard_cfg  = require("lib.standard_cfg")

--------------------------------------------------------------------------------
-- Widgets                                                                    --
--------------------------------------------------------------------------------
require("widgets.awesome-wm-widgets.battery-widget.battery")
require("widgets.awesome-wm-widgets.brightness-widget.brightness")
require("widgets.awesome-wm-widgets.spotify-widget.spotify")
require("widgets.awesome-wm-widgets.volume-widget.volume")

--------------------------------------------------------------------------------
-- Local variables to be used in the configuration section                    --
--------------------------------------------------------------------------------
local widgets = {
   spotify_widget,
   brightness_widget,
   volume_widget,
   battery_widget,
}

local app_rules = {
   {{class = "Chromium-browser"}, {screen = 2, tag = "2"}},
   {{class = "discord"},          {screen = 3, tag = "2"}},
   {{class = "Firefox"},          {screen = 2, tag = "3"}},
   {{class = "Spotify"},          {screen = 1, tag = "1"}},
   {{class = "Thunderbird"},      {screen = 3, tag = "3"}},
}

local app_autostart = {
   "unity-settings-daemon",
   "chromium-browser",
   "discord",
   "spotify"
}
--------------------------------------------------------------------------------
-- Configuration                                                              --
--------------------------------------------------------------------------------
standard_cfg.setup(widgets, keybindings.modkey, "default")
keybindings.setup()
rules.setup(app_rules)
autostart.setup(app_autostart)
