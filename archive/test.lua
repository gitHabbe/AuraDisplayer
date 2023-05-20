-- Create the button frame
local buttonFrame = CreateFrame("Cooldown", "MyButtonFrame", UIParent, "CooldownFrameTemplate")
buttonFrame:ClearAllPoints()
buttonFrame:SetPoint("CENTER") -- Set the position of the button frame
buttonFrame:SetSize(64, 64) -- Set the size of the button frame

-- Set the texture icon of the button frame
buttonFrame.texture = buttonFrame:CreateTexture(nil, "ARTWORK")
buttonFrame.texture:ClearAllPoints()
buttonFrame.texture:SetAllPoints(buttonFrame)
buttonFrame.texture:SetSize(40, 40) -- Set the size of the button frame
buttonFrame.texture:SetTexture("Interface\\Icons\\Ability_Mage_Invisibility")

-- Create the cooldown frame inside the button frame
-- buttonFrame.cooldown = CreateFrame("Cooldown", "MyButtonCooldown", buttonFrame, "CooldownFrameTemplate")
-- buttonFrame.cooldown:SetAllPoints(buttonFrame)

-- Remove the border and backdrop of the cooldown frame
-- buttonFrame.cooldown:SetDrawEdge(false)
-- buttonFrame.cooldown:SetDrawBling(false)

-- Start the cooldown timer
local cooldownStart, cooldownDuration = GetTime(), 10 -- Set cooldownStart to GetTime() and cooldownDuration to 10 seconds
buttonFrame:SetCooldown(cooldownStart, cooldownDuration)
