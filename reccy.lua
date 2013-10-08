-- recursive mining bot attempt

function moveforward(n)
  if (n==0) then return end
  
  turtle.forward() ? 
end

function start()
  moveforward(10)
  forward() ? {put(forward) ... } : (dig(forward)||(deadend()) )
end

