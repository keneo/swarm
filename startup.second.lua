-- startup.second.lua
-- each comp with startup.lua, downloads and runs this script on each time comp/server starts


-- thanks tu startup.lua, folowing functions are already loaded
-- function loadTable()
-- function saveString(sData, sPath)
-- function createAddress(c)
-- function download(sUrl, sPath)

function secondmain()
  
  local tc = loadTable()
  
  local label=os.getComputerLabel()
  
  if (label==nil) then
    label = "unnamed"
  end
  
  
  local localFileName = "comp." .. label .. ".start.lua"
  local githubFileName="autostarts/"..localFileName
  
  tc["filename"]=githubFileName
  download(createAddress(tc),localFileName)
  shell.run(localFileName)
end

secondmain()
