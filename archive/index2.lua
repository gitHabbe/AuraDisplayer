-- Aura = {}
-- Aura.__index = Aura

-- function Aura.new(unitType, i)
-- 	local instance = setmetatable({}, Aura)
-- 	-- instance.frameName = selfName .. "Buff" .. i
-- 	-- instance.frameIcon = _G[frameName .. "Buff" .. i]
--   return instance
-- end
-- local AURA_START_X = 5;
-- local AURA_START_Y = 32;

print("AHabAuras loaded")
local AHabAuras = CreateFrame("Frame", "AHabAuras", UIParent)
AHabAuras:SetPoint("CENTER", UIParent, "CENTER")
AHabAuras:SetSize(200, 100)
AHabAuras:RegisterEvent("PLAYER_TARGET_CHANGED")

AuraDebuff = {}
AuraDebuff.__index = AuraDebuff
function AuraDebuff.new(unitType, i)
  local instance = setmetatable({}, AuraDebuff)
  local name, icon, _, _, _, _, _, _, _, _, _, _, _, _ = UnitDebuff(unitType, i);
	instance.name = name
	instance.icon = icon
  instance.type = "DEBUFF"
  return instance
end

-- Buff = {}
-- Buff.__index = Buff
-- function Buff.new(unitType, i)
--   local instance = setmetatable({}, Buff)
--   local name, icon, _, _, _, _, _, _, _, _, _, _, _, _ = UnitBuff(unitType, i);
-- 	instance.name = name
-- 	instance.icon = icon
--   instance.type = "BUFF"
--   return instance
-- end

Icon = {}
Icon.__index = Icon
function Icon.new(aura)
  local instance = setmetatable({}, Icon)
	instance.aura = aura
	-- instance.icon = aura.icon
  instance.size = 32
  return instance
end

function Icon:create(count, anchorPoint)
  local xAxis = self.size * count
  print(xAxis)
  local cooldownFrame = CreateFrame("Cooldown", "HabIconFrame" .. self.aura.name, AHabAuras, "CooldownFrameTemplate")
  print(anchorPoint)
  cooldownFrame:SetPoint("TOPRIGHT", anchorPoint, "TOPLEFT", xAxis, 0)
  cooldownFrame:SetCooldown(GetTime(), 5 + count)
  cooldownFrame:SetSize(4, 4)
  print("HabIcon" .. self.aura.name)
  local icon = cooldownFrame:CreateTexture("HabIcon" .. self.aura.name, "BACKGROUND")
  icon:SetAllPoints(cooldownFrame)
  icon:SetTexture(self.aura.icon)
  return cooldownFrame
end

AuraPlacer = {}
AuraPlacer.__index = AuraPlacer
function AuraPlacer.new()
  local instance = setmetatable({}, AuraPlacer)
  instance.buffList = {}
  instance.debuffList = {}
  return instance
end

function AuraPlacer:generateIcons()
  local unitType = "target"
  local count = 1

  for i=1, 40 do
    -- local auraBuff = Buff.new(unitType, i)
    local anchorPoint
    if self.buffList[#self.buffList] == nil then
      anchorPoint = AHabAuras
    else
      anchorPoint = self.buffList[#self.buffList]
    end
    if auraBuff.name == nil then break end
    local icon = Icon.new(auraBuff)
    local iconFrame = icon:create(i, anchorPoint)
    table.insert(self.buffList, iconFrame)
  end

  -- count = 1
  -- while UnitDebuff(unitType, count + 1) do
  --   local auraDebuff = AuraDebuff.new(unitType, count)
  --   local anchorPoint

  --   if (self.debuffList[#self.debuffList] == nil) then
      
  --     anchorPoint = AHabAuras
  --   else
  --     anchorPoint = self.debuffList[#self.debuffList]
  --   end
  --   local icon = Icon.new(auraDebuff)
  --   icon:create()
  --   count = count + 1
  --   table.insert(self.debuffList, icon)
  -- end

end


AHabAuras:SetScript("OnEvent", function(self, event, ...)
	if(event == "PLAYER_TARGET_CHANGED") then
		print("AHabAuras: Target Changed")
    local auraplacer = AuraPlacer.new()
    auraplacer:generateIcons()
	end
end)