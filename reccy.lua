-- recursive mining bot attempt

--on slots 2,3,4,5 you need to keep dirt,stone,gravel,stone

-- dont let buggy robot escape you 
maxMoves=5000 --not that buggy now

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
  if (detect() and worth(compare)) then
    repeat
      if (not dig()) then
        write ("\ncancel dig look "..name)
        return
      end
    until move()
    lookaround()
    while not moveBack() do digBack() end --technically endless but you should not find indestructable obstacle on your way back, right ?
  end
end

function horizontalDigBack()
  turtle.turnRight() 
  turtle.turnRight()
  turtle.dig()
  turtle.turnRight() 
  turtle.turnRight()
end

function lookaround()
  look("down",turtle.compareDown,turtle.detectDown,myDown,turtle.digDown,myUp,turtle.digUp)
  
  for s=1,4 do
    look("forw"..s,turtle.compare,turtle.detect,myForward,turtle.dig,myBack,horizontalDigBack)
    turtle.turnRight()
  end
  
  look("up",turtle.compareUp,turtle.detectUp,myUp,turtle.digUp,myDown,turtle.digDown)
end

function moveforward(n)
  if (n==0) then return end
  
  while (not myForward()) do
    if (not turtle.dig()) then
      write ("\ncancel dig forw "..n)
      return
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

function start()
  if (validateStart()) then
    moveforward(4)
  else
    write('validation failed')
  end
end

start()
