local addon = select(2,...)
local path = [[Interface\AddOns\AAAura\assets\]];

local _G = _G
local unpack = unpack

local hooksecurefunc = hooksecurefunc

local function getBuff(unit, i)
	local name, icon, count, debuffType, duration, expirationTime, _, isStealable, _, spellId = UnitBuff(unit, i)
	local buffDebug = name
	if icon 					then buffDebug = buffDebug .. " icon: " .. icon end
	-- if count 					then buffDebug = buffDebug .. " count: " .. count end
	if debuffType 		then buffDebug = buffDebug .. " type: \"" .. debuffType .. "\""end
	if duration 			then buffDebug = buffDebug .. " dur: " .. duration end
	if expirationTime then buffDebug = buffDebug .. " exp: " .. expirationTime end
	print(buffDebug)
	return name, icon, count, debuffType, duration, expirationTime, _, isStealable, _, spellId
end

-- /* create style buffs & debuffs */
function __TargetFrame_UpdateAuras(self)
	-- if maxshows then return end
	local frame, frameName
	local frameIcon, frameCount, frameCooldown
	-- local name, rank, icon, count, debuffType
	local color
	local frameBorder
	local targetFrame = _G[self:GetName()]
	if not targetFrame:IsShown() then return end
	-- if targetFrame:IsShown() then
	print("---")
	for i = 1, MAX_TARGET_BUFFS do
		frameName = self:GetName() .. "Buff" .. i
		frame = _G[frameName]
		if (not frame) then
			print("not frame")
			break
		end
		local name, icon, count, debuffType, duration, expirationTime, _, isStealable, _, spellId = getBuff(self.unit, i)
		if not icon then break end

		local oldSelf, asdf, oldParent = frame:GetPoint()
		-- if i == 1 then
		-- 	frame:SetPoint(oldSelf, asdf, oldParent, 5, 3)
		-- else
		-- 	frame:SetPoint(oldSelf, asdf, oldParent, 0, 0)
		-- end
		-- frame:SetScale(1.8)

		-- print(frame:GetPoint())
			-- frame.styled = true
		-- icons:
		frameIcon = _G[frameName .. "Icon"]
		if frameIcon then
			-- frameIcon:Hide()
			-- frameIcon:SetPoint('TOPLEFT', frame, 'TOPLEFT', 2, -2)
			-- frameIcon:SetPoint('TOPLEFT', frame, 'TOPLEFT', 0, 0)
			-- frameIcon:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -2, 2)
			-- frameIcon:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', 0, 0)
			-- frameIcon:SetTexCoord(unpack(texcoord))
		end
		-- border:
		local bo = _G[frameName .. "Border2"]
		-- print(_G[frameName .. "Border"])
		if not bo then
			bo = frame:CreateTexture(frameName .. "Border2", 'OVERLAY')
			_G[frameName .. "Border2"] = bo
			-- bo = frame:CreateTexture(frameName .. "Border2", 'OVERLAY', [[Interface\Buttons\UI-Debuff-Overlays]])
			-- <Texture name="$parentBorder" file="Interface\Buttons\UI-Debuff-Overlays">
			-- 	<Size x="17" y="17"/>
			-- 	<Anchors>
			-- 		<Anchor point="TOPLEFT" x="-1" y="1"/>
			-- 		<Anchor point="BOTTOMRIGHT" x="1" y="-1"/>
			-- 	</Anchors>
			-- 	<TexCoords left="0.296875" right="0.5703125" top="0" bottom="0.515625"/>
			-- </Texture>
		end
		if bo then
			if debuffType == "Magic" then
				bo:SetTexture([[Interface\Buttons\UI-Debuff-Overlays]])
				bo:SetTexCoord("0.296875", "0.5703125", "0", "0.515625")
				bo:SetVertexColor(0, 0.64, 1)
				bo:SetAllPoints()
				-- bo:SetPoint("TOPLEFT", -1, 1)
				-- bo:SetPoint("BOTTOMRIGHT", 1, -1)
				-- bo:SetPoint("TOPLEFT", 0, 0)
				-- bo:SetPoint("BOTTOMRIGHT", 0, 0)
				-- frame:SetPoint(oldSelf, asdf, oldParent, 1.4, 0)
				local countOld, asdf2, countParent = bo:GetPoint()
				-- <Anchor point="TOPLEFT" x="-1" y="1"/>
				-- <Anchor point="BOTTOMRIGHT" x="1" y="-1"/>
			else
				bo:Hide()
			end
			-- bo:SetPoint("CENTER", -4, 0)
			-- bo:SetPoint("TOPLEFT", asdf2, "TOPLEFT", -1, 0)
			-- bo:SetScale(1.4)
		-- 	bo:SetTexture(path .. "Border.tga")
			-- bo:SetVertexColor(unpack({.3, .3, .3, 1}))
		--   print(bo:GetPoint())
		-- 	-- bo:SetSize(2, 2)
		end
		-- count:
		frameCount = _G[frameName..'Count']
		if frameCount then
			local countOld, asdf2, countParent = frameCount:GetPoint()
			frameCount:SetPoint("CENTER", asdf2, "TOPLEFT")
			frameCount:SetScale(0.6)

			
			-- frameCount:SetJustifyH('LEFT')
			-- frameCount:SetSize(7, 7)
			-- frameCount:SetFontObject('pUiFont_Auras')
			frameCount:SetDrawLayer('OVERLAY', 7)
			-- frameCount:Hide()
		end
		-- cooldown:
		frameCooldown = _G[frameName..'Cooldown']
		if frameCooldown then
			-- frameCooldown:SetSwipeTexture(frameIcon:GetTexture())
			-- frameCooldown:Hide()

			-- frameCooldown:ClearAllPoints()
			-- frameCooldown:SetPoint('TOPLEFT', frame, 1.5, -1.5)
			-- frameCooldown:SetPoint('BOTTOMRIGHT', frame, -1.5, 1.5)
			-- frameCooldown:SetFrameLevel(frame:GetFrameLevel())
		end
	-- 		if i == MAX_TARGET_BUFFS then
	-- 			maxshows = true
	-- 		end
	-- 	end
	-- end
	-- for i = 1, MAX_TARGET_DEBUFFS do
	-- 	frame = _G[self:GetName()..'Debuff'..i]
	-- 	if (not frame) then break end
	-- 	if (not frame.styled) then
	-- 		frame:SetScale(DEBUFFS_SCALE)
	-- 		frame.styled = true
	-- 		-- icons:
	-- 		frameIcon = _G[self:GetName()..'Debuff'..i..'Icon']
	-- 		if frameIcon then
	-- 			frameIcon:SetPoint('TOPLEFT', frame, 'TOPLEFT', 2, -2)
	-- 			frameIcon:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -2, 2)
	-- 			frameIcon:SetTexCoord(unpack(texcoord))
	-- 		end
	-- 		-- border:
	-- 		local bo = frame:CreateTexture(nil, 'OVERLAY', nil, 7)
	-- 		if bo then
	-- 			bo:SetTexture(src.border)
	-- 			bo:SetAllPoints()
	-- 		end
	-- 		-- color:
	-- 		local debuffName = UnitDebuff(self.unit, i)
	-- 		_,_,_,_, debuffType = UnitDebuff(self.unit, i)
	-- 		if debuffName then
	-- 			color = DebuffTypeColor[debuffType] or DebuffTypeColor.none
	-- 			frameBorder = _G[self:GetName()..'Debuff'..i..'Border']
	-- 			frameBorder:Hide()
	-- 			if color then
	-- 				bo:SetVertexColor(color.r, color.g, color.b)
	-- 			end
	-- 		else
	-- 			bo:SetVertexColor(unpack(config.border_color))
	-- 		end
	-- 		-- count:
	-- 		frameCount = _G[self:GetName()..'Debuff'..i..'Count']
	-- 		if frameCount then
	-- 			frameCount:SetJustifyH('CENTER')
	-- 			frameCount:SetFontObject('pUiFont_Auras')
	-- 			frameCount:SetDrawLayer('OVERLAY', 7)
	-- 		end
	-- 		-- cooldown:
	-- 		frameCooldown = _G[self:GetName()..'Debuff'..i..'Cooldown']
	-- 		if frameCooldown then
	-- 			frameCooldown:ClearAllPoints()
	-- 			frameCooldown:SetPoint('TOPLEFT', frame, 1.5, -1.5)
	-- 			frameCooldown:SetPoint('BOTTOMRIGHT', frame, -1.5, 1.5)
	-- 		end
	-- 		if i == MAX_TARGET_DEBUFFS then
	-- 			maxshows = true
	-- 		end
		-- end
	end
	-- end
end

hooksecurefunc('TargetFrame_UpdateAuras', __TargetFrame_UpdateAuras)