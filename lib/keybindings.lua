local awful                = require("awful")
local hotkeys_popup        = require("awful.hotkeys_popup").widget
local beautiful            = require("beautiful")
local gears                = require("gears")
local menubar              = require("menubar")
local keybindings_callback = require("lib.keybindings_callback")
local standard_cfg         = require("lib.standard_cfg")
local var = {}

-- Usually, Mod4 is the key with a logo between Control and Alt.
local modkey = "Mod4"
local altkey = "Mod1"

local function mkKeybinding(modifiers, key, command, descript, key_group)
   return awful.key(modifiers, key, command, {description = descript, group = key_group})
end

local function mkKeys(keybindings)
   local createdKeybindings = {}
   for _,keybind in ipairs(keybindings) do
      local modifier     = keybind[1]
      local key          = keybind[2]
      local command      = keybind[3]
      local descript     = keybind[4]
      local key_group    = keybind[5]
      local new_keybind  = mkKeybinding(modifier, key, command, descript, key_group)
      createdKeybindings = gears.table.join(createdKeybindings, new_keybind)
   end
   return createdKeybindings
end

local clientbuttons = gears.table.join(
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
   awful.button({ modkey }, 1, awful.mouse.client.move),
   awful.button({ modkey }, 3, awful.mouse.client.resize))

local clientkeys = mkKeys(
   {
      {{modkey,          }, "f",      keybindings_callback.toggle_fullscreen,            "toggle fullscreen",  "Client"},
      {{modkey, "Shift"  }, "c",      function (c) c:kill()              end,            "close",              "Client"},
      {{modkey, "Control"}, "space",  awful.client.floating.toggle          ,            "toggle floating",    "Client"},
      {{modkey, "Control"}, "Return", function (c) c:swap(awful.client.getmaster()) end, "move to master",     "Client"},
      {{modkey, "Shift"  }, "u",      function (c) c:move_to_screen()               end, "move to screen",     "Client"},
      {{modkey,          }, "t",      function (c) c.ontop = not c.ontop            end, "toggle keep on top", "Client"},
      {{modkey,          }, "n",      keybindings_callback.minimize,                     "minimize",           "Client"},
      {{modkey,          }, "m",      keybindings_callback.maximize,                     "maximize",           "Client"}
   }
)

local function mouse()
   local mymainmenu = standard_cfg.mymainmenu()
   root.buttons(gears.table.join(
		   awful.button({ }, 3, function () mymainmenu:toggle() end),
		   awful.button({ }, 4, awful.tag.viewnext),
		   awful.button({ }, 5, awful.tag.viewprev)
   ))
end

local function keyboard()
   local mymainmenu = standard_cfg.mymainmenu()
   keysToCreate =
      {
	 {{modkey           }, "s",                    hotkeys_popup.show_help,                                             "show help",                             "Awesome"        },
	 {{modkey           }, "Left",                 awful.tag.viewprev,                                                  "view previous",                         "Tag"            },
	 {{modkey           }, "Right",                awful.tag.viewnext,                                                  "view next",                             "Tag"            },
	 {{modkey           }, "Escape",               awful.tag.history.restore,                                           "go back",                               "Tag"            },
	 {{modkey           }, "k",                    function () awful.client.focus.byidx( 1) end,                        "focus next by index",                   "Client"         },
	 {{modkey           }, "j",                    function () awful.client.focus.byidx(-1) end,                        "focus previous by index",               "Client"         },
	 {{modkey           }, "w",                    function () mymainmenu:show() end,                                   "show main menu",                        "Awesome"        },
	 -- Layout manipulation
	 {{modkey, "Shift"  }, "k",                    function () awful.client.swap.byidx( 1) end,                         "swap with next client by index",        "Client"         },
	 {{modkey, "Shift"  }, "j",                    function () awful.client.swap.byidx(-1) end,                         "swap with previous client by index",    "Client"         },
	 {{modkey, "Shift"  }, "o",                    function () awful.screen.focus_relative(-1) end,                     "focus the next screen",                 "Screen"         },
	 {{modkey, "Shift"  }, "p",                    function () awful.screen.focus_relative(1) end,                      "focus the previous screen",             "Screen"         },
	 {{modkey           }, "u",                    awful.client.urgent.jumpto,                                          "jump to urgent client",                 "Client"         },
	 {{altkey           }, "Tab",                  keybindings_callback.alt_tab,                                        "go back",                               "Client"         },
	 -- Standard program
	 {{modkey           }, "Return",               function () awful.spawn(standard_cfg.terminal) end,                  "open a terminal",                       "Launcher"       },
	 {{modkey, "Control"}, "r",                    awesome.restart,                                                     "reload awesome",                        "Awesome"        },
	 {{modkey, "Shift"  }, "q",                    awesome.quit,                                                        "quit awesome",                          "Awesome"        },
	 {{modkey,          }, "l",                    function () awful.tag.incmwfact( 0.05)          end,                 "increase master width factor",          "Layout"         },
	 {{modkey,          }, "h",                    function () awful.tag.incmwfact(-0.05)          end,                 "decrease master width factor",          "Layout"         },
	 {{modkey, "Shift"  }, "h",                    function () awful.tag.incnmaster( 1, nil, true) end,                 "increase the number of master clients", "Layout"         },
	 {{modkey, "Shift"  }, "l",                    function () awful.tag.incnmaster(-1, nil, true) end,                 "decrease the number of master clients", "Layout"         },
	 {{modkey, "Control"}, "h",                    function () awful.tag.incncol( 1, nil, true)    end,                 "increase the number of columns",        "Layout"         },
	 {{modkey, "Control"}, "l",                    function () awful.tag.incncol(-1, nil, true)    end,                 "decrease the number of columns",        "Layout"         },
	 {{modkey,          }, "space",                function () awful.layout.inc( 1)                end,                 "select next",                           "Layout"         },
	 {{modkey, "Shift"  }, "space",                function () awful.layout.inc(-1)                end,                 "select previous",                       "Layout"         },
	 {{modkey, "Shift"  }, "n",                    keybindings_callback.restore_minimized,                              "restore minimized",                     "Client"         },
	 -- Prompt
	 {{modkey           }, "r",                    function () awful.screen.focused().mypromptbox:run() end,            "run prompt",                            "Launcher"       },
	 {{modkey           }, "x",                    keybindings_callback.lua_exec_prompt,                                "lua execute prompt",                    "Awesome"        },
	 -- Menubar
	 {{modkey           }, "p",                    function() menubar.show() end,                                       "show the menubar",                      "Launcher"       },
	 -- Volume keys
	 {{                 }, "XF86AudioLowerVolume", function () awful.spawn("amixer -D pulse sset Master 5%-") end,      "increase volume",                       "Volume keys"    },
	 {{                 }, "XF86AudioRaiseVolume", function () awful.spawn("amixer -D pulse sset Master 5%+") end,      "decrease volume",                       "Volume keys"    },
	 {{                 }, "XF86AudioMute",        function () awful.spawn("amixer -D pulse set Master +1 toggle") end, "mute volume",                           "Volume keys"    },
	 -- Media keys
	 {{                 }, "XF86AudioPlay",        function () awful.spawn("sp play") end,                              "Spotify Play/Pause",                    "Media keys"     },
	 {{                 }, "XF86AudioPrev",        function () awful.spawn("sp prev") end,                              "Spotify prev",                          "Media keys"     },
	 {{                 }, "XF86AudioNext",        function () awful.spawn("sp next") end,                              "Spotify next",                          "Media keys"     },
	 -- Brightness keys
	 {{                 }, "XF86MonBrightnessUp",  function () awful.spawn("light -A 5") end,                           "Increase brightness",                   "Brightness keys"},
	 {{                 }, "XF86MonBrightnessDown",function () awful.spawn("light -U 5") end,                           "Decrease brightness",                   "Brightness keys"}
   }

   -- Bind all key numbers to tags.
   -- Be careful: we use keycodes to make it works on any keyboard layout.
   -- This should map on the top row of your keyboard, usually 1 to 9.
   for i = 1, 9 do
      table.insert(keysToCreate, {{modkey                     }, "#" .. i + 9, keybindings_callback.focus_tag(i),            "view tag #"..i,                       "Tag"})
      table.insert(keysToCreate, {{modkey, "Control"          }, "#" .. i + 9, keybindings_callback.toggle_tag(i),           "toggle tag #" .. i,                   "Tag"})
      table.insert(keysToCreate, {{modkey, "Shift"            }, "#" .. i + 9, keybindings_callback.move_client_to_tag(i),   "move focused client to tag #"..i,     "Tag"})
      table.insert(keysToCreate, {{modkey, "Control", "Shift" }, "#" .. i + 9, keybindings_callback.toggle_client_on_tag(i), "toggle focused client on tag #" .. i, "Tag"})
   end

   globalkeys = mkKeys(keysToCreate)
   root.keys(globalkeys)
end

local function setup()
   mouse()
   keyboard()
end

var.clientbuttons = clientbuttons
var.clientkeys    = clientkeys
var.modkey        = modkey
var.setup         = setup

return var
