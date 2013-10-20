-- this startup should download fresh startup.second.lua and call it
--exports:

--require
--require_try

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

function ensureNewest(localFileName)
  
  if (fs.exists("/.git")) then  
    -- we're running in the working copy - probably we're the source of everything. if not - do: git pull
  else
  
    local tc = loadTable()
    local githubFileName = localFileName
    
    tc["filename"]=githubFileName
    download(createAddress(tc),localFileName)
  end
end


local alreadyRequired = {}

function require(filename)
  if (not alreadyRequired[filename]) then
    write(filename .. "...")
    alreadyRequired[filename]=true
    ensureNewest(filename)
    if (fs.exists(filename)) then
      write("go\n")
      shell.run(filename)
    else
      write("miss\n")
      error("require('".. filename .."'): failed. file not found")
    end
  end  
end

function require_try(filename)
  return pcall(function() require(filename) end)
end


function main()
  
  require("startup.second.lua")
  
end


main()
