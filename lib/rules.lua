--------------------------------------------------------------------------------
-- Standard awesome library                                                   --
--------------------------------------------------------------------------------
local awful       = require("awful")
local beautiful   = require("beautiful")
local screen_lib  = require("awful.screen")

--------------------------------------------------------------------------------
-- User defined libraries                                                     --
--------------------------------------------------------------------------------
local keybindings = require("lib.keybindings")

--------------------------------------------------------------------------------
-- Local variables/functions                                                  --
--------------------------------------------------------------------------------
local function mkRule(new_rule,new_prop)
   return { rule = new_rule, properties = new_prop }
end

local function mkAnyRule(new_rule, new_prop)
   return {rule_any = new_rule, properties = new_prop }
end

local function insertRule(rule)
   table.insert(awful.rules.rules, rule)
end

--------------------------------------------------------------------------------
-- Exported variables/functions                                               --
--------------------------------------------------------------------------------
local function setup(rules)
   insertRule(mkRule({},{
		    border_width = beautiful.border_width,
		    border_color = beautiful.border_normal,
		    focus = awful.client.focus.filter,
		    raise = true,
		    keys = keybindings.clientkeys,
		    buttons = keybindings.clientbuttons,
		    screen = awful.screen.preferred,
		    placement = awful.placement.no_overlap+awful.placement.no_offscreen}))

   insertRule(mkAnyRule({instance = {"DTA",        -- Firefox addon DownThemAll.
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
			}, {floating = true}))



   insertRule(mkAnyRule({type = {"normal", "dialog"}}, {titlebars_enabled = false}))

   for _,rule in ipairs(rules) do
      local new_rule = mkRule(rule[1], rule[2])
      insertRule(new_rule)
   end
end


return {setup = setup}
