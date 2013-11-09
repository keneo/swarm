--find the newest version source at https://raw.github.com/keneo/swarm/master/installer.lua
--find the newest version pastebin and instructions at https://github.com/keneo/swarm/blob/master/InstallOnline.md

if not http then
	print( "Installer requires http API" )
	print( "Set enableAPI_http to true in ComputerCraft.cfg" )
  print( "Installation FAILED" )
	return
end

githubUser = ({...})[1] or "keneo"

print( "Installing swarm from github user '"..githubUser.."'... " )

local url = "https://raw.github.com/"..githubUser.."/swarm/master/startup.lua"

local sFile = "startup"
local sPath = shell.resolve( sFile )

write( "Connecting to github... " )
local response = http.get(url)
	
if response then
	print( "Success." )
  write( "Downloading..." )
	
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


