-- recursive mining bot


shell.run("trackedTurtle.lua")
--shell.run("common.lua")

-- dont let buggy robot escape you 

stackDepthMax=500  -- we disallow recursion deeper than stackDepthMax
stackDepthCurrent=0 
--TODO:stackoverflow usually indicates bug that leads to escape, so when detected we should just directly return home for safety

rozkopDefaultSize=1


function dec() stackDepthCurrent=stackDepthCurrent-1 end
function inctry() stackDepthCurrent=stackDepthCurrent+1; if (stackDepthCurrent==stackDepthMax) then dec() return false else return true end end




function worth(c)
  for p=2,6 do --slots containing unintresting ores
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
  dec()
end

function validateStart()
  if (turtle.getItemCount(2)==0) then return false end
  if (turtle.getItemCount(3)==0) then return false end
  if (turtle.getItemCount(4)==0) then return false end
  if (turtle.getItemCount(5)==0) then return false end
  if (turtle.getItemCount(6)==0) then return false end
  return true
end

function reccy(n)
  log('requested moveforward '..n)
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
