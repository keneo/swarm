-- recursive mining bot attempt

--on slots 2,3,4,5 you need to keep dirt,stone,gravel,stone

-- dont let buggy robot escape you 
maxMoves=5000 --not that buggy now
stackDepthMax=20  -- we disallow recursion deeper than stackDepthMax
stackDepthCurrent=0 
--TODO:stackoverflow usually indicates bug that leads to escape, so when detected we shoul just directly return home for safety

function dec() stackDepthCurrent=stackDepthCurrent-1 end
function inctry() stackDepthCurrent=stackDepthCurrent+1; if (stackDepthCurrent==stackDepthMax) then dec() return false else return true end end


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

function look(name,compare,detect,move,dig,moveBack,digBack)
  write("\n"..name)
  if (not inctry()) then return end
  
  if (detect() and worth(compare)) then
    repeat
      if (not dig()) then
        write ("\ncancel dig look "..name)
        dec() return
      end
    until move()
    lookaround()
    while not moveBack() do digBack() end --technically endless but you should not find indestructable obstacle on your way back, right ?
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
  
  while (not myForward()) do
    if (not turtle.dig()) then
      write ("\ncancel dig forw "..n)
      dec() return
    end
  end
  
  lookaround()
  moveforward(n-1)
  while not myBack() do horizontalDigBack() end
end

function validateStart()
  if (turtle.getItemCount(2)==0) then return false end
  if (turtle.getItemCount(3)==0) then return false end
  if (turtle.getItemCount(4)==0) then return false end
  if (turtle.getItemCount(5)==0) then return false end
  return true
end

function start(n)
  write('requested moveforward '..n)
  if (validateStart()) then
    moveforward(n)
  else
    write('validation failed')
  end
end

arg = ({...})[1]
order = tonumber(arg) or 10
start(order)
