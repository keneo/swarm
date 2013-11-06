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

  ensureNewest("gitget")

  if (not fs.exists("autostarts")) then
    fs.makeDir("autostarts")
  end
  
  if (turtle~=nil) then
    require_try("all.turtles.start.lua")
  end  
 
  require_try("autostarts/comp." .. (os.getComputerLabel() or "unnamed") .. ".start.lua")
  
end

secondmain()
