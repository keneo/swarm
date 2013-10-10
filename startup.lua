-- Loads a table from file
function loadTable()
  sPath="gitget.cfg"
  if not fs.exists(sPath) then
    error("loadTable() file not found: " .. sPath)
  end
 
  if fs.isDir(sPath) then
    error("loadTable() cannot open a directory")
  end
 
  local file = fs.open(sPath, "r")
  local sTable = file.readAll()
  file.close()
  return textutils.unserialize(sTable)
end

function createAddress(tConfig)
  local sUrl = "https://raw.github.com"
  tConfig["filename"] = string.gsub(tConfig["filename"], "%s", "%%20")
  return (sUrl .. "/" .. tConfig["user"] .. "/" .. tConfig["project"] .. "/" .. tConfig["branch"] .. "/" .. tConfig["filename"])
end

-- Downloads a file from url provided
function download(sUrl, sPath)
  print("Downloading: " .. sUrl)
  if http then
    local sData = http.get(sUrl)
   
    if sData then
      print("Fetched file")
      return saveString(sData.readAll(), sPath)
    else
      print("Failed to fetch file: " .. sUrl)
      return false
    end
   
  else
    error("download() needs http api enabled to fetch files")
  end
end


tConfig = loadTable()

local label=os.getComputerLabel()
local localFileName = "comp." .. label .. ".start.lua"
local githubFileName="autostarts/"..localFileName

tConfig["filename"]=githubFileName
download(createAddress(tConfig),localFileName)
shell.run(localFileName)
