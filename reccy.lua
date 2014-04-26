-- recursive mining bot


local trackedTurtle = require("trackedTurtle.lua")
--shell.run("common.lua")

-- dont let buggy robot escape you 

stackDepthMax=500  -- we disallow recursion deeper than stackDepthMax
stackDepthCurrent=0 
--TODO:stackoverflow usually indicates bug that leads to escape, so when detected we should just directly return home for safety

rozkopDefaultSize=1

local cancelling = false


function dec() stackDepthCurrent=stackDepthCurrent-1 end
function inctry() 
  if (cancelling or stackDepthCurrent==stackDepthMax) then 
    cancelling=true 
    return false 
  else stackDepthCurrent=stackDepthCurrent+1; return true end 
end


local mytu = trackedTurtle or turtle

function worth(c)
  for p=2,6 do --slots containing unintresting ores
    mytu.select(p)
    if (c()) then
      mytu.select(2)
      return false
    end
  end
  mytu.select(2)
  return true
end

function tryuntil(action,retrys)
  for i=1,retrys do
    local r = action()
    if (r) then return true end
  end
  return false
end

local space_problem = false

function ensure_have_place()
  if (mytu.getItemCount(16)==0) then 
    space_problem=false
    return true 
  else
    if (space_problem) then
      return false
    end -- else go compress
  end --ok
  
  --else need compress 
  
  --on pattern slots drop every duplicaets
  for i=2,6 do
    local c = mytu.getItemCount(i)
    if (c>1) then
      mytu.select(i)
      mytu.drop(c-1)
    end
  end
  
  local emptyslot=nil
  
  --drop unintresting
  for i=7,16 do
    mytu.select(i)
    local intresting=true
    
    if (mytu.getItemCount(i)==0) then
      emptyslot=i
    end
    
    for u=2,6 do
      if (mytu.compareTo(u)) then
        intresting=false
      end
    end
    
    if (not intresting) then
      mytu.drop()
      emptyslot=i
    end
  end
  
  if (emptyslot) then
    mytu.select(16)
    mytu.transferTo(emptyslot)
    mytu.select(2)
    space_problem = false
    return true
  else
    mytu.select(2)
    log("could not empty")
    space_problem = true
    return false
  end
  
end

function look(dir,compare,detect,move,dig,moveBack,digBack, rozkop)
  if (not inctry()) then return end
    
  if (detect()) then
    local foundsth = worth(compare)
    
    if (foundsth) then 
      log("found sth on "..dir) 
      if (not ensure_have_place()) then
        cancelling = true
        return
      end
    end
    
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
  mytu.dig()
  myTurnRight() 
  myTurnRight()
end

function lookaround(rozkop)
  if (not inctry()) then return end
  
  if (rozkop>0) then log("lookaround with rozkop"..rozkop) end
  
  look("down",mytu.compareDown,mytu.detectDown,myDown,mytu.digDown,myUp,mytu.digUp, rozkop)
  
  for s=1,4 do
    look("forw"..s,mytu.compare,mytu.detect,myForward,mytu.dig,myBack,horizontalDigBack, rozkop)
    myTurnRight()
  end
  
  look("up",mytu.compareUp,mytu.detectUp,myUp,mytu.digUp,myDown,mytu.digDown, rozkop)
  
  dec()
end

function moveforward(n)
  if (n==0) then return end
  if (not inctry()) then return end
  
  log ("mining forward "..n)
  while (not myForward()) do
    if (not tryuntil(mytu.dig,5)) then
      log ("cancel dig forw "..n)
      dec() return
    end
  end
  
  lookaround(0)
  moveforward(n-1)
  while not myBack() do log("removing unexpected obstacle") horizontalDigBack() end
  dec()
end

function validateStart()
  for i=2,6 do
    if (mytu.getItemCount(i)==0) then return false end
  end
  return true
end

function reccy(n)
  log('requested moveforward '..n)
  cancelling = false
  if (validateStart()) then
    moveforward(n)
    log("finished")
  else
    log('validation failed. on slots 2,3,4,5,6 you should keep following items (order does not matter): dirt,stone,gravel,cobblestone,torch')
  end
end

local arg = ({...})[1]

if (arg~=nil) then
  local order = tonumber(arg) or 10
  reccy(order)
else
  log("reccy api loaded. no actions taken")
end
