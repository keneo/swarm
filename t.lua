t=trackedTurtle or turtle
d={["f"]=t.forward,["u"]=t.up,["d"]=t.down,["b"]=t.back,["l"]=t.turnLeft,["r"]=t.turnRight,["F"]=t.dig,["U"]=t.digUp,["D"]=t.digDown,["P"]=t.place,["_"]=function()end}
({...})[1]:gsub(".",function(c)
if(c:find("%d"))then t.select(c)
else d[c]()
end end)
