-- recursive mining bot attempt

--on slots 2,3,4,5 you need to keep dirt,stone,gravel,stone

-- dont let buggy robot escape you 
maxMoves=5000 --not that buggy now
stackDepthMax=500  -- we disallow recursion deeper than stackDepthMax
stackDepthCurrent=0 
--TODO:stackoverflow usually indicates bug that leads to escape, so when detected we shoul just directly return home for safety

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
  local ls = (" "):rep(stackDepthCurrent)..textutils.serialize(s).."\n"
  write(ls)
  file.write(ls)
  file.close()
end

function myForward()
  maxMoves=maxMoves-1
  if (maxMoves>0) then
    return turtle.forward()
  end
  return false
end
function myBack()
  maxMoves=maxMoves-1
  if (maxMoves>0) then
    return turtle.back()
  end
  return false
end
function myUp()
  maxMoves=maxMoves-1
  if (maxMoves>0) then
    return turtle.up()
  end
  return false
end
function myDown()
  maxMoves=maxMoves-1
  if (maxMoves>0) then
    return turtle.down()
  end
  return false
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

function look(dir,compare,detect,move,dig,moveBack,digBack)
  if (not inctry()) then return end
  
  if (detect() and worth(compare)) then
    log("found sth on "..dir)
    repeat
      if (not dig()) then
        log ("cancel dig look "..dir)
        dec() return
      end
    until move()
    lookaround()
    while not moveBack() do log("removing unexpected obstacle") digBack() end --technically endless but you should not find indestructable obstacle on your way back, right ?
  end
  
  dec()
end

function horizontalDigBack()
  turtle.turnRight() 
  turtle.turnRight()
  turtle.dig()
  turtle.turnRight() 
  turtle.turnRight()
end

function lookaround()
  if (not inctry()) then return end
  
  look("down",turtle.compareDown,turtle.detectDown,myDown,turtle.digDown,myUp,turtle.digUp)
  
  for s=1,4 do
    look("forw"..s,turtle.compare,turtle.detect,myForward,turtle.dig,myBack,horizontalDigBack)
    turtle.turnRight()
  end
  
  look("up",turtle.compareUp,turtle.detectUp,myUp,turtle.digUp,myDown,turtle.digDown)
  
  dec()
end

function moveforward(n)
  if (n==0) then return end
  if (not inctry()) then return end
  
  log ("mining forward "..n)
  while (not myForward()) do
    if (not turtle.dig()) then
      log ("cancel dig forw "..n)
      dec() return
    end
  end
  
  lookaround()
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
