-- recursive mining bot attempt

function worth(c)
  for p=1,3 do --unintresting
    turtle.select(p)
    if (c()) then
      return false
    end
  end
  return true
end

function lookY(name,compare,move,dig,moveBack)
  if (worth(compare)) then
    repeat
      if (not dig()) then
        write ("cancel dig look y "..name)
        return
      end
    until not move()
    lookaround()
    moveBack()
  end
end

function lookaround()
  lookY("up",turtle.compareUp,turtle.up,turtle.digUp,turtle.down)
  lookY("down",turtle.compareDown,turtle.down,turtle.digDown,turtle.up)
  
  for s=1,4 do
    lookY("forw",turtle.compare,turtle.forward,turtle.dig,turtle.back)
    turtle.turnRight()
  end
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

moveforward(10)
--  forward() ? {put(forward) ... } : (dig(forward)||(deadend()) )

