-- startup.second.lua
-- each comp with startup.lua, downloads and runs this script on each time comp/server starts


-- thanks to startup.lua, folowing functions are already loaded
-- function require(filename)
-- function ensureNewest(filename)
-- function loadTable()
-- function saveString(sData, sPath)
-- function createAddress(c)
-- function download(sUrl, sPath)

function secondmain()

  if (not fs.exists("autostarts")) then
    fs.makeDir("autostarts")
  end
  
  if (turtle~=nil) then
    require("all.turtles.start.lua")
  end  
 
  require("autostarts/comp." .. (os.getComputerLabel() or "unnamed") .. ".start.lua")
  
end

secondmain()
