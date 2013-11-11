local function package()
  return {
    --pos_hash = pos_hash,
    location = location,
    set_walkable = set_walkable,
    is_walkable = is_walkable,    
  }
end

local geotable = {}

local function pos_hash(pos)
	return pos.x + 10000*pos.y + 100000000*pos.z
end

local function location(pos)
  local h = pos_hash(pos)  
  local v = geotable[h]
  
  if (not v) then
    v = {}
    geotable[h]=v
  end
  
  return v
end

local function set_walkable(pos,walkable)
  local l=location(pos)
  l.walkable=walkable
  l.walkable_timestamp = os.day()*100 + os.time()
end

local function is_walkable(pos)
  local l=location(pos)
  return l.walkable
end



export = package()

map = export

return export