local _, Aura = ...

local Settings = Aura.Settings
local Buff = Aura.Buff
local Button = Aura.Button
print("AHabAuras loaded")
local AHabAuras = CreateFrame("Frame", "AHabAuras", UIParent)
AHabAuras:SetPoint("CENTER", UIParent, "CENTER")
AHabAuras:SetSize(1, 1)
AHabAuras:RegisterEvent("PLAYER_TARGET_CHANGED")
AHabAuras:RegisterUnitEvent("UNIT_AURA", "target")



Grid = {}
Grid.__index = Grid
function Grid.new()
  local instance = setmetatable({}, Grid)
  instance.cachedBuffs = {}
  instance.newRows = {}
  instance.currentWidth = 0
  return instance
end

function Grid:resetBuffs()
  self.currentWidth = 0
  self.newRows = {}
  for i = 1, #self.cachedBuffs do
    -- self.cachedBuffs[i]:Hide()
    self.cachedBuffs[i]:Reset(self.cachedBuffs[i])
  end
end

function Grid:renderBuffs()
  for i = 1, 40 do
    local buff = Buff.new("target", i)
    if buff == nil then break end
    local button = self:__getButton(i, buff)
    button:style()
    local frame = button.frame
    frame = self:__setAnchor(button)


    self.currentWidth = self.currentWidth + buff:size()

  end
end

function Grid:__getButton(i, aura)
  if self.cachedBuffs[i] == nil then
    self.cachedBuffs[i] = Button.new(aura, i)
  else
    self.cachedBuffs[i]:Show()
  end
  return self.cachedBuffs[i]
end

function Grid:__setAnchor(button)
  local frame = button.frame
  if #self.newRows == 0 then
    self:__setFirstAura(frame)
  elseif self.currentWidth >= Settings.maxAuraWidth then
    self:__setNewRowAura(frame, button)
  else
    self:__setNormalAura(frame, button)
  end
  return frame
end

function Grid:__setFirstAura(frame)
  frame:SetPoint("TOPLEFT", "SUFUnittarget", "BOTTOMLEFT", 4, 2)
  self.newRows[#self.newRows + 1] = frame
end

function Grid:__setNewRowAura(frame, button)
  frame:SetPoint("TOPLEFT", self.newRows[#self.newRows], "BOTTOMLEFT", 0, -2)
  self.newRows[#self.newRows + 1] = frame
  self.currentWidth = button.aura:size()
end

function Grid:__setNormalAura(frame, button)
  local xOffset = frame.aura:size() * 0.08
  frame:SetPoint("TOPLEFT", self.cachedBuffs[button.aura.i - 1].frame, "TOPRIGHT", xOffset, 0)
end



local grid = Grid.new()
AHabAuras:SetScript("OnEvent", function(self, event, ...)
	if(event == "PLAYER_TARGET_CHANGED") then
		print("AHabAuras: Target Changed")
    grid:resetBuffs()
    grid:renderBuffs()
    print("buff length: " .. grid.currentWidth)
    -- testCode()
  elseif (event == "UNIT_AURA") then
    -- print("Auras changes")
	end
end)

-- function Grid:createRow()
  
-- end