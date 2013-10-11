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

-- Saves a string to file
function saveString(sData, sPath)
  if fs.isDir(sPath) then
    error("saveString() cannot save over a directory")
  end
 
  local file = fs.open(sPath, "w")
  file.write(sData)
  file.close()
  return true
end

function createAddress(c)
  local sUrl = "https://raw.github.com"
  c["filename"] = string.gsub(c["filename"], "%s", "%%20")
  return (sUrl .. "/" .. c["user"] .. "/" .. c["project"] .. "/" .. c["branch"] .. "/" .. c["filename"])
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

function main()
  
  local tc = loadTable()
  
  local label=os.getComputerLabel()
  local localFileName = "comp." .. label .. ".start.lua"
  local githubFileName="autostarts/"..localFileName
  
  tc["filename"]=githubFileName
  download(createAddress(tc),localFileName)
  shell.run(localFileName)
end

main()
