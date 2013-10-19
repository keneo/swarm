-- recursive mining bot

-- on slots 2,3,4,5 you need to keep dirt,stone,gravel,cobblestone


-- dont let buggy robot escape you 
maxMoves=5000 
stackDepthMax=500  -- we disallow recursion deeper than stackDepthMax
stackDepthCurrent=0 
--TODO:stackoverflow usually indicates bug that leads to escape, so when detected we should just directly return home for safety

rozkopDefaultSize=1


function dec() stackDepthCurrent=stackDepthCurrent-1 end
function inctry() stackDepthCurrent=stackDepthCurrent+1; if (stackDepthCurrent==stackDepthMax) then dec() return false else return true end end

-- Loads a table from file
function loadTable(sPath)
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
 
-- Saves a table to file
-- Uses saveString()
function saveTable(tData, sPath)
  local sSerializedData = textutils.serialize(tData)
  return saveString(sSerializedData, sPath)
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

function log(s)
  local file = fs.open("log", "a")
  local ls = pos .. (" "):rep(stackDepthCurrent)..textutils.serialize(s).."\n"
  write(ls)
  file.write(ls)
  file.close()
end


local pos,dir

function ensure_locate()
  while (dir==nil) do 
    locate() 
  end
end

function locate()
  log("finding position...")
  pos=vector.new(gps.locate(5))
  if (pos.x==nil) then log("failed. TODO manual entry of position and/or ask to continue without this") return end
  log("finding face direction...")
  if (turtle.forward()) then
    local x2,y2,z2=gps.locate(5)
    turtle.back()
    if (x2=nil) then log("failed. went out of gps range?") return end
    if (z2<pos.z) then dir=0 log("north") return end
    if (z2>pos.z) then dir=2 log("south") return end
    if (x2>pos.x) then dir=1 log("east") return end
    if (x2<pos.x) then dir=3 log("west") return end
    log("??? not possible. we moved but possition did not changed?")
    return    
  else
    log("failed. TODO try go other directions and/or ask to continue without this")
    return
  end
end

local vectorsByDirPlus1 = {
  vector.new(0,0,-1),
  vector.new(1,0,0),
  vector.new(0,0,1),
  vector.new(-1,0,0)
}

function getDirVector()
  return vectorsByDirPlus1(dir+1)
end

function myForward()
  ensure_locate()
  maxMoves=maxMoves-1
  if (maxMoves>0) then
    local ret = turtle.forward()
    if (ret) then pos=pos+getDirVector() end
    return ret
  end
  return false
end

function myBack()
  ensure_locate()
  maxMoves=maxMoves-1
  if (maxMoves>0) then
    local ret = turtle.back()
    if (ret) then pos=pos-getDirVector() end
    return ret
  end
  return false
end

function myUp()
  ensure_locate()
  maxMoves=maxMoves-1
  if (maxMoves>0) then
    local ret = turtle.up()
    pos.y=pos.y+1
    return ret
  end
  return false
end

function myDown()
  ensure_locate()
  maxMoves=maxMoves-1
  if (maxMoves>0) then
    local ret = turtle.down()
    pos.y=pos.y-1
    return ret
  end
  return false
end

function myTurnLeft()
  ensure_locate()
  turtle.turnLeft()
  dir=(dir-1)%4
end

function myTurnRight()
  ensure_locate()
  turtle.turnRight()
  dir=(dir+1)%4
end


function setMaxMoves(n)
  maxMoves=n
end



function worth(c)
  for p=2,5 do --unintresting
    turtle.select(p)
    if (c()) then
      return false
    end
  end
  return true
end

function tryuntil(action,retrys)
  for i=1,retrys do
    local r = action()
    if (r) then return true end
  end
  return false
end

function look(dir,compare,detect,move,dig,moveBack,digBack, rozkop)
  if (not inctry()) then return end
    
  if (detect()) then
    local foundsth = worth(compare)
    
    if (foundsth) then log("found sth on "..dir) end
    
    if (foundsth or rozkop>0) then
      repeat
        if (not tryuntil(dig,5)) then
          log ("cancel on "..dir)
          dec() return
        end
      until move()

      lookaround(foundsth and rozkopDefaultSize or rozkop-1)
      
      while not moveBack() do log("removing unexpected obstacle") digBack() end --technically endless but you should not find indestructable obstacle on your way back, right ?
    end
  end
  
  dec()
end

function horizontalDigBack()
  myTurnRight() 
  myTurnRight()
  turtle.dig()
  myTurnRight() 
  myTurnRight()
end

function lookaround(rozkop)
  if (not inctry()) then return end
  
  if (rozkop>0) then log("lookaround with rozkop"..rozkop) end
  
  look("down",turtle.compareDown,turtle.detectDown,myDown,turtle.digDown,myUp,turtle.digUp, rozkop)
  
  for s=1,4 do
    look("forw"..s,turtle.compare,turtle.detect,myForward,turtle.dig,myBack,horizontalDigBack, rozkop)
    myTurnRight()
  end
  
  look("up",turtle.compareUp,turtle.detectUp,myUp,turtle.digUp,myDown,turtle.digDown, rozkop)
  
  dec()
end

function moveforward(n)
  if (n==0) then return end
  if (not inctry()) then return end
  
  log ("mining forward "..n)
  while (not myForward()) do
    if (not tryuntil(turtle.dig,5)) then
      log ("cancel dig forw "..n)
      dec() return
    end
  end
  
  lookaround(0)
  moveforward(n-1)
  while not myBack() do log("removing unexpected obstacle") horizontalDigBack() end
end

function validateStart()
  if (turtle.getItemCount(2)==0) then return false end
  if (turtle.getItemCount(3)==0) then return false end
  if (turtle.getItemCount(4)==0) then return false end
  if (turtle.getItemCount(5)==0) then return false end
  return true
end

function start(n)
  log('requested moveforward '..n)
  if (validateStart()) then
    moveforward(n)
  else
    log('validation failed')
  end
end

arg = ({...})[1]
order = tonumber(arg) or 10
start(order)
