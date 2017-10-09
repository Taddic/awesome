--------------------------------------------------------------------------------
-- Standard awesome library                                                   --
--------------------------------------------------------------------------------
local awful = require("awful")

--------------------------------------------------------------------------------
-- Local functions                                                            --
--------------------------------------------------------------------------------
local function run_once(app)
   local fpid = io.popen("pgrep " .. app)
   local pid = fpid:read("*n")
   fpid:close()

   if pid == nil then
      awful.spawn.with_shell(app)
   end
end

--------------------------------------------------------------------------------
-- Exported functions                                                         --
--------------------------------------------------------------------------------
local function setup(apps)
   awful.spawn.easy_async("numlockx on")
   for _,app in ipairs(apps) do
      run_once(app)
   end
end

return {setup = setup}
