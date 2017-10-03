local awful = require("awful")

local var = {}

local function applications(apps)
   awful.spawn.easy_async("numlockx on")
   for _,app in ipairs(apps) do
      awful.spawn.with_shell(app)
   end
end

var.applications = applications

return var
