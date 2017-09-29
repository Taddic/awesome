local awful = require("awful")

local var = {}

local function applications()
   awful.spawn.easy_async("numlockx on")
   awful.spawn.with_shell("spotify")
   awful.spawn.with_shell("chromium-browser")
   awful.spawn.with_shell("discord")
   awful.spawn.with_shell("thunderbird")
   --awful.spawn.with_shell("./home/jgo107/git/eTodo/_build_default/rel/bin/eTodo")
end

var.applications = applications

return var
