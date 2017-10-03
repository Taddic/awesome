-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Theme handling library
local beautiful = require("beautiful")

local var = {}

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

local function setup(wibox, widgets)
   -- Keyboard map indicator and switcher
   mykeyboardlayout = awful.widget.keyboardlayout()

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
   -- }}}

   --- Create a wibox for each screen and add it
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
	 awful.tag(
	    { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
	    s, awful.layout.layouts[1])

	 -- Create a promptbox for each screen
	 s.mypromptbox = awful.widget.prompt()
	 -- Create an imagebox widget which will contain an
	 -- icon indicating which layout we're using.
	 -- We need one layoutbox per screen.
	 s.mylayoutbox = awful.widget.layoutbox(s)
	 s.mylayoutbox:buttons(
	    awful.util.table.join(
	       awful.button({ }, 1, function () awful.layout.inc( 1) end),
	       awful.button({ }, 3, function () awful.layout.inc(-1) end),
	       awful.button({ }, 4, function () awful.layout.inc( 1) end),
	       awful.button({ }, 5, function () awful.layout.inc(-1) end)))
	 -- Create a taglist widget
	 s.mytaglist = awful.widget.taglist(
	    s, awful.widget.taglist.filter.all, taglist_buttons)

	 -- Create a tasklist widget
	 s.mytasklist = awful.widget.tasklist(
	    s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

	 -- Create the wibox
	 s.mywibox = awful.wibar({ position = "top", screen = s })


	 right_widgets = {layout = wibox.layout.fixed.horizontal}
	 for _,w in ipairs(widgets) do
	    table.insert(right_widgets, w)
	    table.insert(right_widgets, separator)
	 end
	 table.insert(right_widgets, mykeyboardlayout)
	 table.insert(right_widgets, wibox.widget.systray())
	 table.insert(right_widgets, mytextclock)
	 table.insert(right_widgets, s.mylayoutbox)



	 -- Add widgets to the wibox
	 s.mywibox:setup {
	    layout = wibox.layout.align.horizontal,
	    { -- Left widgets
	       layout = wibox.layout.fixed.horizontal,
	       mylauncher,
	       s.mytaglist,
	       s.mypromptbox,
	    },
	    s.mytasklist, -- Middle widget
	    right_widgets
	 }
   end)
end

var.set_wallpaper = set_wallpaper
var.setup = setup
return var
