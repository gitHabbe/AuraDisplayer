local _, ns = ...

Buff = {}
Buff.__index = Buff
function Buff.new(unit, i)
  local instance = setmetatable({}, Buff)
  local name, icon, _, _, dur, exp, source, _, _, id, _, _, _, _ = UnitBuff(unit, i)
  if name == nil then return nil end
  if source ~= nil then instance.source = source end
	instance.id = id
	instance.name = name
	instance.icon = icon
  instance.i = i
  instance.dur = dur
  instance.exp = exp
  instance.type = "BUFF"
  print("buff: #" ..  i .. ", name: " .. name .. ", icon: " .. icon)
  return instance
end

function Buff:size()
  if self.source == "player" then
    return ns.Settings.playerAuraSize
  end
  return ns.Settings.otherAuraSize
end

function Buff:duration()
  if self.dur ~= 0 and self.exp ~= 0 then
    return self.exp - self.dur, self.dur
  end
  return GetTime(), 0
end

ns.Buff = Buff