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

function look(name,compare,move,dig,moveBack)
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
  look("up",turtle.compareUp,turtle.up,turtle.digUp,turtle.down)
  look("down",turtle.compareDown,turtle.down,turtle.digDown,turtle.up)
  
  for s=1,4 do
    look("forw",turtle.compare,turtle.forward,turtle.dig,turtle.back)
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

