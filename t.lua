t=turtle
a={...}
p=a[1]
d={["f"]=t.forward,["u"]=t.up,["d"]=t.down}
p:gsub(".",function(c)
d[c]()
end
