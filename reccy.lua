-- recursive mining bot attempt

--on slots 2,3,4 you need to keep dirt,stone and gravel


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
  look("down",turtle.compareDown,turtle.detectDown,turtle.down,turtle.digDown,turtle.up)
  
  for s=1,4 do
    look("forw"..s,turtle.compare,turtle.detect,turtle.forward,turtle.dig,turtle.back)
    turtle.turnRight()
  end
  
  look("up",turtle.compareUp,turtle.detectUp,turtle.up,turtle.digUp,turtle.down)
end

function moveforward(n)
  if (n==0) then return end
  
  while (not turtle.forward()) do
    if (not turtle.dig()) then
      write ("cancel dig forw "..n)
      return
    end
  end
  
  lookaround()
  moveforward(n-1)
  turtle.back()
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

