function t(code)
  local t=turtle
  d={
    ["f"]=t.forward,
    ["u"]=t.up,
    ["d"]=t.down,
    ["b"]=t.back,
    ["l"]=t.turnLeft,
    ["r"]=t.turnRight,
    ["F"]=t.dig,
    ["U"]=t.digUp,
    ["D"]=t.digDown,
    ["P"]=t.place,
    ["_"]=function()end
  }
  
  code:gsub(".",
                      function(c)
                        if c:find("%d")
                          then 
                            t.select(c)
                          else 
                            d[c]()
                        end
  end)
end

function stairsUp(k)
  t(string.rep("uUFfUFD",k))
end
