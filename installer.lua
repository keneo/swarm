--wget https://raw.github.com/keneo/swarm/master/startup.lua

if not http then
	print( "Installer requires http API" )
	print( "Set enableAPI_http to true in ComputerCraft.cfg" )
  print( "Installation FAILED" )
	return
end

local url = "https://raw.github.com/keneo/swarm/master/startup.lua"

local sFile = "startup"
local sPath = shell.resolve( sFile )

write( "Downloading... " )
local response = http.get(url)
	
if response then
	print( "Success." )
	
	local sResponse = response.readAll()
	response.close()
	
	local file = fs.open( sPath, "w" )
	file.write( sResponse )
	file.close()
	
	print( "Downloaded as "..sFile )
  print( "Starting..." )
  
  shell.run("startup")
	
else
	print( "Failed." )
end	


