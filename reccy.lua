-- recursive mining bot attempt

function roadclear()
  turtle.dig()
end

function lookY(name,c,m,d)
  if (worth(c)) then
    while (not m()) do 
      if (not d()) then
        write ("cancel dig look y "..name)
        return
      end
    end
  end
end

function lookaround()
  lookY("up",turtle.compareUp,turtle.up,turtle.digUp)
  lookY("down",turtle.compareDown,turtle.down,turtle.digDown)
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

