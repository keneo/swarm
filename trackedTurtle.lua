

-- dont let buggy robot escape you 
maxMoves=5000 

local pos,dir

function log(s)
  local file = fs.open("log", "a")
  local postxt="nopos"
  if (pos~=nil) then
    postxt=pos.x..","..pos.y..","..pos.z
  end
  
  local ls =  postxt .. " " .. (" "):rep(stackDepthCurrent or 0)..textutils.serialize(s).."\n"
  write(ls)
  file.write(ls)
  file.close()
end

function ensure_locate()
  while (dir==nil) do 
    locate() 
    sleep(1)
  end
end

function locate_gps_or_manual()
  local x,y,z=gps.locate(5)
  if (x==nil) then
    log("gps.locate failed. nedd manual entry")
    print("enter coords in form: x y z")
    local str = read()
    require("split.lua")
    local t=split(str," ")    
    x,y,z = t[1],t[2],t[3]
  end
  return x,y,z
end

function locate()
  log("finding position...")
  local x,y,z=locate_gps_or_manual(5)
  if (x==nil) then
    log("lua failed")
    return
  end
  
  log("gps located: "..(x or "nil")..","..(y or "nil")..","..(z or "nil"))
  pos=vector.new(x,y,z)
  if (pos.x==nil) then log("failed. TODO manual entry of position and/or ask to continue without this") return end
  log("finding face direction...")
  if (turtle.forward()) then
    local x2,y2,z2=locate_gps_or_manual()
    turtle.back()
    if (x2==nil) then log("failed. went out of gps range?") return end
    if (z2<pos.z) then dir=0 log("north") return end
    if (z2>pos.z) then dir=2 log("south") return end
    if (x2>pos.x) then dir=1 log("east") return end
    if (x2<pos.x) then dir=3 log("west") return end
    log("??? not possible. we moved but possition did not changed?")
    return    
  else
    log("failed. TODO try go other directions and/or ask to continue without this")
    return
  end
end

local vectorsByDirPlus1 = {
  vector.new(0,0,-1),
  vector.new(1,0,0),
  vector.new(0,0,1),
  vector.new(-1,0,0)
}

function getDirVector()
  return vectorsByDirPlus1[dir+1]
end

function getPos()
  return pos
end

function myForward()
  ensure_locate()
  maxMoves=maxMoves-1
  if (maxMoves>0) then
    local ret = turtle.forward()
    local targetpos = pos+getDirVector() --todo addition in place
    if (ret) then 
      pos=targetpos
    end
    if (map) then map.set_walkable(targetpos,ret) end
    return ret
  end
  return false
end

function myBack()
  ensure_locate()
  maxMoves=maxMoves-1
  if (maxMoves>0) then
    local ret = turtle.back()
    local targetpos = pos-getDirVector() --todo addition in place
    if (ret) then pos=targetpos end
    if (map) then map.set_walkable(targetpos,ret) end
    return ret
  end
  return false
end

local vectorUp = vector.new(0,1,0)
local vectorDown = vector.new(0,-1,0)


function myUp()
  ensure_locate()
  maxMoves=maxMoves-1
  if (maxMoves>0) then
    local ret = turtle.up()
    pos.y=pos.y+1
    if (map) then map.set_walkable(pos,ret) end
    return ret
  else
    if (map) then map.set_walkable(pos+vectorUp,ret) end
    return false
  end
end

function myDown()
  ensure_locate()
  maxMoves=maxMoves-1
  if (maxMoves>0) then
    local ret = turtle.down()
    pos.y=pos.y-1
    if (map) then map.set_walkable(pos,ret) end
    return ret
  else
    if (map) then map.set_walkable(pos+vectorDown,ret) end
    return false
  end
end

function myTurnLeft()
  ensure_locate()
  turtle.turnLeft()
  dir=(dir-1)%4
end

function myTurnRight()
  ensure_locate()
  turtle.turnRight()
  dir=(dir+1)%4
end

local function mydetect(tfunc,vec)
  local ret = tfunc()
  if (map) then map.set_walkable(pos+vec,not ret) end
  return ret
end

function setMaxMoves(n)
  maxMoves=n
end

local function package()
  return {
    forward=myForward,
    back=myBack,
    turnLeft=myTurnLeft,
    turnRight=myTurnRight,
    up=myUp,
    down=myDown,
    dig=turtle.dig,
    digUp=turtle.digUp,
    digDown=turtle.digDown,
    select=turtle.select,
    compare=turtle.compare,
    compareDown=turtle.compareDown,
    compareUp=turtle.compareUp,
    compareTo=turtle.compareTo,
    transferTo=turtle.transferTo,
    detect    =function() return mydetect(turtle.detect,getDirVector()) end,
    detectDown=function() return mydetect(turtle.detectDown,vectorDown) end,
    detectUp  =function() return mydetect(turtle.detectUp,vectorDown) end,
    getItemCount=turtle.getItemCount,
    drop=turtle.drop,
    place=turtle.place,
    placeUp=turtle.placeUp,
    placeDown=turtle.placeDown,
    getFuelLevel=turtle.getFuelLevel,
  } 
end


export = package()
trackedTurtle = export
return export
