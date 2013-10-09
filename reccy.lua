-- recursive mining bot attempt

--on slots 2,3,4 you need to keep dirt,stone and gravel

-- dont let buggy robot escape you 
maxMoves=10
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



function worth(c)
  for p=2,4 do --unintresting
    turtle.select(p)
    if (c()) then
      return false
    end
  end
  return true
end

function look(name,compare,detect,move,dig,moveBack)
  write(name)
  if (worth(compare)) then
    repeat
      if (not dig()) then
        write ("cancel dig look "..name)
        return
      end
    until not move()
    lookaround()
    moveBack()
  end
end

function lookaround()
  look("down",turtle.compareDown,turtle.detectDown,myDown,turtle.digDown,myUp)
  
  for s=1,4 do
    look("forw"..s,turtle.compare,turtle.detect,myForward,turtle.dig,myBack)
    turtle.turnRight()
  end
  
  look("up",turtle.compareUp,turtle.detectUp,myUp,turtle.digUp,myDown)
end

function moveforward(n)
  if (n==0) then return end
  
  while (not myForward()) do
    if (not turtle.dig()) then
      write ("cancel dig forw "..n)
      return
    end
  end
  
  lookaround()
  moveforward(n-1)
  myBack()
end

function validateStart()
  if (turtle.getItemCount(2)==0) then return false end
  if (turtle.getItemCount(3)==0) then return false end
  if (turtle.getItemCount(4)==0) then return false end
  return true
end

if (validateStart()) then
  moveforward(10)
else
  write('validation failed')
end
--  forward() ? {put(forward) ... } : (dig(forward)||(deadend()) )

