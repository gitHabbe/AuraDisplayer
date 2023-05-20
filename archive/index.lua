print("AHabAuras loaded")
local AHabAuras = CreateFrame("Frame", "AHabAuras", UIParent)
AHabAuras:SetPoint("CENTER", UIParent, "CENTER")
AHabAuras:SetSize(1, 1)
AHabAuras:RegisterEvent("PLAYER_TARGET_CHANGED")
AHabAuras:RegisterUnitEvent("UNIT_AURA", "target")
local cachedFrames = {}
local rowLength = 0
local maxLength = 100
local newRows = {}

local function createFrame(previous, i)
  local anchorPoint = previous or AHabAuras
  
  local CD = cachedFrames[i]
  if CD == nil then
    cachedFrames[i] = CreateFrame("Cooldown", "HabIconFrame" .. i, anchorPoint, "CooldownFrameTemplate")
    CD = cachedFrames[i]
    CD.texture = CD:CreateTexture(nil, "BACKGROUND")
    -- table.insert(newRows, CD)
    
    -- print("creating new icon")
  else
    -- print("using old icon")
  end
  return CD, anchorPoint
end

local function createIcon(i, icon, previous)
  local CD, anchorPoint = createFrame(previous, i)
  CD:ClearAllPoints()
  if i == 1 then
    CD:SetPoint("TOPLEFT", "SUFUnittarget", "BOTTOMLEFT", 3, 0)
    -- newRows[#newRows+1] = CD
    print(#newRows)
  else
    CD:SetPoint("TOPLEFT", anchorPoint, "TOPRIGHT", 0, 0)
  end
  
  CD:SetCooldown(GetTime(), 10 + math.random(-5, 5))
  local size = 50
  if (i < 3) then size = 70 end
  CD:SetSize(size, size)
  CD.texture:SetTexture(icon)
  CD.texture:SetAllPoints(CD)
  if #newRows == 0 then
    newRows[#newRows+1] = CD
  end
  rowLength = rowLength + size
  if rowLength >= maxLength then
    CD:SetPoint("TOPLEFT", newRows[#newRows], "BOTTOMLEFT", 0, 0)
    newRows[#newRows+1] = CD
    rowLength = 0
  end
  return CD
end

local function resetIcons()
  -- print("reseting table, length: " .. #cachedFrames)
  rowLength = 0
  newRows = {}
  for i=1, #cachedFrames do
    -- print(i)
    cachedFrames[i]:Hide()
    -- print(" " .. cachedFrames[i]:Hide())
  end
end

local function renderIcons()
  resetIcons()
  local unitType = "target"
  local count = 1
  local previous
  
  for i=1, 40 do
    local name, icon, _, _, _, _, _, _, _, _, _, _, _, _ = UnitBuff(unitType, i);
    if not name then
      break
    end
    print("buff: " .. name .. " #" .. count .. ", icon: " .. icon)
    count = count + 1
    previous = createIcon(i, icon, previous)
  end
end

local function testCode()

end

AHabAuras:SetScript("OnEvent", function(self, event, ...)
	if(event == "PLAYER_TARGET_CHANGED") then
		print("AHabAuras: Target Changed")
    renderIcons()
    print("buff length: " .. rowLength)
    -- testCode()
  elseif (event == "UNIT_AURA") then
    -- print("Auras changes")
	end
end)