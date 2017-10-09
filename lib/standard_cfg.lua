-- Standard awesome library
local awful     = require("awful")
local beautiful = require("beautiful") -- Theme handling library
local gears     = require("gears")
local menubar   = require("menubar")
local naughty   = require("naughty")   -- Notification library
local wibox     = require("wibox")
require("awful.autofocus")
require("debian.menu")                                             -- Load Debian menu entries

-- Local variables
local terminal = "x-terminal-emulator"
local editor = os.getenv("EDITOR") or "editor"
local editor_cmd = terminal .. " -e " .. editor
local var  = {}

local myawesomemenu = {
   { "hotkeys",     function() return false, hotkeys_popup.show_help end},
   { "manual",      terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart",     awesome.restart },
   { "quit",        function() awesome.quit() end}}

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

local function layouts()
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
   }
end

local function menu()
   menubar.utils.terminal = terminal -- Set the terminal for applications that require it
end

local function mymainmenu()
   return awful.menu({
	 items = {
	    {"awesome",       myawesomemenu, beautiful.awesome_icon},
	    {"Debian",        debian.menu.Debian_menu.Debian},
	    {"open terminal", terminal}}})
end

local function set_wallpaper(s)
   -- Wallpaper
   if beautiful.wallpaper then
      local wallpaper = beautiful.wallpaper
      -- If wallpaper is a function, call it with the screen
      if type(wallpaper) == "function" then
	 wallpaper = wallpaper(s)
      end
      gears.wallpaper.maximized(wallpaper, s, true)
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

local function setup(widgets)
   error_handling()
   theme()
   layouts()
   menu()

   -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
   screen.connect_signal("property::geometry", set_wallpaper)

   -- {{{ Wibar
   -- Create a textclock widget
   mytextclock = wibox.widget.textclock()

   -- Widget seperator
   separator = wibox.widget.textbox()
   separator:set_text(" : ")

   -- {{{ Helper functions
   local function client_menu_toggle_fn()
      local instance = nil

      return function ()
	 if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
	 else
            instance = awful.menu.clients({ theme = { width = 250 } })
	 end
      end
   end

   -- Create a wibox for each screen and add it
   local taglist_buttons = awful.util.table.join(
      awful.button({ }, 1, function(t) t:view_only() end),
      awful.button({ modkey }, 1, function(t)
	    if client.focus then
	       client.focus:move_to_tag(t)
	    end
      end),
      awful.button({ }, 3, awful.tag.viewtoggle),
      awful.button({ modkey }, 3, function(t)
	    if client.focus then
	       client.focus:toggle_tag(t)
	    end
      end),
      awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
      awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
   )

   local tasklist_buttons = awful.util.table.join(
      awful.button({ }, 1, function (c)
	    if c == client.focus then
	       c.minimized = true
	    else
	       -- Without this, the following
	       -- :isvisible() makes no sense
	       c.minimized = false
	       if not c:isvisible() and c.first_tag then
		  c.first_tag:view_only()
	       end
	       -- This will also un-minimize
	       -- the client, if needed
	       client.focus = c
	       c:raise()
	    end
      end),

      awful.button({ }, 3, client_menu_toggle_fn()),
      awful.button({ }, 4, function ()
	    awful.client.focus.byidx(1)
      end),
      awful.button({ }, 5, function ()
	    awful.client.focus.byidx(-1)
   end))

   awful.screen.connect_for_each_screen(function(s)
	 -- Wallpaper
	 set_wallpaper(s)

	 -- Each screen has its own tag table.
	 awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

	 -- Create a promptbox for each screen
	 s.mypromptbox = awful.widget.prompt()
	 -- Create an imagebox widget which will contains an icon indicating which layout we're using.
	 -- We need one layoutbox per screen.
	 s.mylayoutbox = awful.widget.layoutbox(s)
	 s.mylayoutbox:buttons(awful.util.table.join(
				  awful.button({ }, 1, function () awful.layout.inc( 1) end),
				  awful.button({ }, 3, function () awful.layout.inc(-1) end),
				  awful.button({ }, 4, function () awful.layout.inc( 1) end),
				  awful.button({ }, 5, function () awful.layout.inc(-1) end)))
	 -- Create a taglist widget
	 s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

	 -- Create a tasklist widget
	 s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

	 -- Create the wibox
	 s.mywibox = awful.wibar({ position = "top", screen = s })

	 right_widgets = {layout = wibox.layout.fixed.horizontal}
	 for _,w in ipairs(widgets) do
	    table.insert(right_widgets, w)
	    table.insert(right_widgets, separator)
	 end
	 table.insert(right_widgets, wibox.widget.systray())
	 table.insert(right_widgets, mytextclock)
	 table.insert(right_widgets, s.mylayoutbox)

	 -- Add widgets to the wibox
	 s.mywibox:setup {
	    layout = wibox.layout.align.horizontal,
	    { -- Left widgets
	       layout = wibox.layout.fixed.horizontal,
	       s.mytaglist,
	       s.mypromptbox
	    },
	    s.mytasklist, -- Middle widget
	    right_widgets
	 }
   end)

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
end

var.error_handling = error_handling
var.layouts        = layouts
var.menu           = menu
var.mymainmenu     = mymainmenu
var.setup          = setup
var.set_wallpaper  = set_wallpaper
var.terminal       = terminal
var.theme          = theme
return var
