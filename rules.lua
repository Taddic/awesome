local awful = require("awful")
local beautiful = require("beautiful")
local keybindings = require("keybindings")

local var = {}

local function setup()
   local function mkAnyRule(new_rule, new_prop)
      return {rule_any = new_rule, properties = new_prop }
   end

   local function mkRule(new_rule,new_prop)
      return { rule = new_rule, properties = new_prop }
   end

   awful.rules.rules = {
      -- All clients will match this rule.
      mkRule({},{ border_width = beautiful.border_width,
		  border_color = beautiful.border_normal,
		  focus = awful.client.focus.filter,
		  raise = true,
		  keys = keybindings.clientkeys,
		  buttons = keybindings.clientbuttons,
		  screen = awful.screen.preferred,
		  placement = awful.placement.no_overlap+awful.placement.no_offscreen}),

      mkAnyRule({instance = {"DTA",        -- Firefox addon DownThemAll.
			     "copyq",      -- Includes session name in class.
			    },
		 class    = {"Arandr",
			     "Gpick",
			     "Kruler",
			     "MessageWin", -- kalarm.
			     "Sxiv",
			     "Wpa_gui",
			     "pinentry",
			     "veromix",
			     "xtightvncviewer"},
		 name = {"Event Tester"},  -- xev.
		 role = {"AlarmWindow",    -- Thunderbird's calendar.
			 "pop-up"}         -- Google Chrome's (detached) Dev Tools.
		}, {floating = true}),


      -- Add titlebars to normal clients and dialogs
      mkAnyRule({type = {"normal", "dialog"}}, {titlebars_enabled = false}),

      mkRule({class = "Firefox"},          {screen = 2, tag = "3"}),
      mkRule({class = "Spotify"},          {screen = 1, tag = "1"}),
      mkRule({class = "Chromium-browser"}, {screen = 2, tag = "2"}),
      mkRule({class = "discord"},          {screen = 3, tag = "2"}),
      mkRule({class = "Thunderbird"},      {screen = 3, tag = "3"})

   }

end
var.setup = setup

return var
