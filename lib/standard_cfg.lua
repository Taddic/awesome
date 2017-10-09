local awful     = require("awful")     -- Standard awesome library
local beautiful = require("beautiful") -- Theme handling library
local gears     = require("gears")     -- Standard awesome library
local menubar   = require("menubar")
local naughty   = require("naughty")   -- Notification library

local terminal = "x-terminal-emulator"
local editor = os.getenv("EDITOR") or "editor"
local editor_cmd = terminal .. " -e " .. editor
local var  = {}

local function error_handling()
   -- {{{ Error handling
   -- Check if awesome encountered an error during startup and fell back to
   -- another config (This code will only ever execute for the fallback config)
   if awesome.startup_errors then
      naughty.notify({ preset = naughty.config.presets.critical,
		       title = "Oops, there were errors during startup!",
		       text = awesome.startup_errors })
   end

   -- Handle runtime errors after startup
   do
      local in_error = false
      awesome.connect_signal(
	 "debug::error", function (err)
	    -- Make sure we don't go into an endless error loop
	    if in_error then return end
	    in_error = true
	    naughty.notify({ preset = naughty.config.presets.critical,
			     title = "Oops, an error happened!",
			     text = tostring(err) })
	    in_error = false
      end)
   end
end

local function theme()
   -- Themes define colours, icons, font and wallpapers.
   beautiful.init("~/.config/awesome/themes/default/theme.lua")
   local user_wallpaper = awful.util.get_configuration_dir() .. "wallpaper/background.png"
   if gears.filesystem.file_readable(user_wallpaper) then
      beautiful.wallpaper = user_wallpaper
   end
end

local function layouts()
   -- Table of layouts to cover with awful.layout.inc, order matters.
   awful.layout.layouts = {
      awful.layout.suit.floating,
      awful.layout.suit.tile,
      awful.layout.suit.tile.left,
      awful.layout.suit.tile.bottom,
      awful.layout.suit.tile.top,
      awful.layout.suit.fair,
      awful.layout.suit.fair.horizontal,
      awful.layout.suit.spiral,
      awful.layout.suit.spiral.dwindle,
      awful.layout.suit.max,
      awful.layout.suit.max.fullscreen,
      awful.layout.suit.magnifier,
      awful.layout.suit.corner.nw,
      -- awful.layout.suit.corner.ne,
      -- awful.layout.suit.corner.sw,
      -- awful.layout.suit.corner.se,
   }
end

local function menu()
   menubar.utils.terminal = terminal -- Set the terminal for applications that require it
end

var.editor_cmd     = editor_cmd
var.error_handling = error_handling
var.layouts        = layouts
var.menu           = menu
var.terminal       = terminal
var.theme          = theme
return var
