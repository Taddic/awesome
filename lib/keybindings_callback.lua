local awful = require("awful")
local var = {}

local function alt_tab() awful.client.focus.history.previous()
   if client.focus then
      client.focus:raise()
   end
end

local function focus_tag(i)
   return function()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
	 tag:view_only()
      end
   end
end

local function lua_exec_prompt()
   awful.prompt.run {
      prompt       = "Run Lua code: ",
      textbox      = awful.screen.focused().mypromptbox.widget,
      exe_callback = awful.util.eval,
      history_path = awful.util.get_cache_dir() .. "/history_eval"
   }
end

local function maximize(c)
   c.maximized = not c.maximized
   c:raise()
end

local function minimize(c)
   -- The client currently has the input focus, so it cannot be
   -- minimized, since minimized clients can't have the focus.
   c.minimized = true
end

local function move_client_to_tag(i)
   return function()
      if client.focus then
	 local tag = client.focus.screen.tags[i]
	 if tag then
	    client.focus:move_to_tag(tag)
	 end
      end
   end
end

local function restore_minimized()
   local c = awful.client.restore()
   -- Focus restored client
   if c then
      client.focus = c
      c:raise()
   end
end

local function toggle_client_on_tag(i)
   return function()
      if client.focus then
	 local tag = client.focus.screen.tags[i]
	 if tag then
	    client.focus:toggle_tag(tag)
	 end
      end
   end
end


local function toggle_fullscreen(c)
   c.fullscreen = not c.fullscreen
   c:raise()
end

local function toggle_tag(i)
   return function()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
	 awful.tag.viewtoggle(tag)
      end
   end
end

var.alt_tab              = alt_tab
var.focus_tag            = focus_tag
var.lua_exec_prompt      = lua_exec_prompt
var.maximize             = maximize
var.minimize             = minimize
var.move_client_to_tag   = move_client_to_tag
var.restore_minimized    = restore_minimized
var.toggle_client_on_tag = toggle_client_on_tag
var.toggle_fullscreen    = toggle_fullscreen
var.toggle_tag           = toggle_tag

return var
