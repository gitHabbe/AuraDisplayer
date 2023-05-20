local _, ns = ...

Button = {}
Button.__index = Button
function Button.new(aura, i)
  local instance = setmetatable({}, Button)
  instance.aura = aura
  instance.frame = instance:__create("HabButton" .. i)
  return instance
end

function Button:__create(frameName)
  -- local buttonFrame = CreateFrame("Button", nil, AHabAuras)
  local buttonFrame = CreateFrame("Button", nil, AHabAuras, "TargetBuffFrameTemplate")
  _G[frameName] = buttonFrame
  -- buttonFrame.cooldown = CreateFrame("Cooldown", "HabIconFrame" .. self.aura.i, AHabAuras, "CooldownFrameTemplate")
  local cooldownFrame = CreateFrame("Cooldown", "HabIconFrame" .. self.aura.i, AHabAuras, "CooldownFrameTemplate")
  _G[frameName .. "Cooldown"] = cooldownFrame
  
  local iconFrame = buttonFrame:CreateTexture(nil, "BACKGROUND")
  _G[frameName .. "Icon"] = iconFrame
  -- buttonFrame.icon = buttonFrame:CreateTexture(nil, "BACKGROUND")
  local borderFrame = buttonFrame:CreateTexture(nil, "OVERLAY")
  _G[frameName .. "Border"] = borderFrame
  -- buttonFrame.border = buttonFrame:CreateTexture(nil, "OVERLAY")
  -- buttonFrame.border:SetPoint("CENTER", buttonFrame)
  -- buttonFrame.border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
  -- buttonFrame.border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
  -- buttonFrame.border:SetSize(46, 46)
  -- buttonFrame.border:SetVertexColor(0.2, 0.6, 1.0)
  -- buttonFrame.border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
  -- buttonFrame.border:SetTexCoord(0.07, 0.93, 0.07, 0.93)

  -- buttonFrame.cooldown:SetBackdrop({
  --   bgFile = "Interface\\Buttons\\WHITE8x8",
  --   edgeFile = "Interface\\Buttons\\UI-Debuff-Border",
  --   edgeSize = 16,
  --   insets = { left = 4, right = 4, top = 4, bottom = 4 },
  -- })


  return buttonFrame
end

function Button:style()
  -- self.frame:ClearAllPoints()
  -- self.frame:SetSize(self.aura:size(), self.aura:size())
  -- self.frame.aura = self.aura

  -- self.frame.cooldown:SetAllPoints(self.frame)
  -- self.frame.cooldown:SetPoint("CENTER", self.frame)
  -- self.frame.cooldown:SetSwipeTexture(self.aura.icon) -- Thank you twitch.tv/tomcat
  -- self.frame.cooldown:SetCooldown(self.aura:duration())
  -- self.frame.cooldown:SetEdgeScale(1.24)

  -- self.frame.icon:SetTexture(self.aura.icon)
  -- self.frame.icon:SetAllPoints(self.frame)

  -- self.frame.border = self.frame:CreateTexture(nil, "OVERLAY")
  -- self.frame.border:SetSize(self.aura:size() * 1.11, self.aura:size() * 1.05)
  -- self.frame.border:SetPoint("LEFT", self.frame, "LEFT", self.aura:size() * -0.09, 0)
  -- self.frame.border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
  -- self.frame.border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
  -- self.frame.border:Show()
  local frame = _G[]
  self.frame:ClearAllPoints()
  self.frame:SetSize(self.aura:size(), self.aura:size())
  self.frame.aura = self.aura

  self.frame.cooldown:SetAllPoints(self.frame)
  self.frame.cooldown:SetPoint("CENTER", self.frame)
  self.frame.cooldown:SetSwipeTexture(self.aura.icon) -- Thank you twitch.tv/tomcat
  self.frame.cooldown:SetCooldown(self.aura:duration())
  self.frame.cooldown:SetEdgeScale(1.24)

  self.frame.icon:SetTexture(self.aura.icon)
  self.frame.icon:SetAllPoints(self.frame)

  self.frame.border = self.frame:CreateTexture(nil, "OVERLAY")
  self.frame.border:SetSize(self.aura:size() * 1.11, self.aura:size() * 1.05)
  self.frame.border:SetPoint("LEFT", self.frame, "LEFT", self.aura:size() * -0.09, 0)
  self.frame.border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
  self.frame.border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
  self.frame.border:Show()
end

function Button:Show()
  self.frame.cooldown:Show()
  self.frame.border:Show()
  self.frame.icon:Show()
  self.frame:Show()
end

function Button:Hide()
  self.frame.cooldown:Hide()
  self.frame.border:Hide()
  self.frame.icon:Hide()
  self.frame:Hide()
end

function Button:Reset(frame)
    -- frame:ClearAllPoints()
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    frame:SetSize(0, 0)
    frame:SetAlpha(1)
    frame:SetScale(1)
    frame:SetFrameLevel(1)
    frame:SetFrameStrata("MEDIUM")
    frame:Show()
end

ns.Button = Button