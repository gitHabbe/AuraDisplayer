-- aura positioning constants
local AURA_START_X = 5;
local AURA_START_Y = 32;
local AURA_OFFSET_Y = 1;
local LARGE_AURA_SIZE = 21;
local SMALL_AURA_SIZE = 17;
local AURA_ROW_WIDTH = 122;
local TOT_AURA_ROW_WIDTH = 101;
local NUM_TOT_AURA_ROWS = 2;	-- TODO: replace with TOT_AURA_ROW_HEIGHT functionality if this becomes a problem
local MAX_TARGET_BUFFS = 80;
local MAX_TARGET_DEBUFFS = 80;
local _G = _G
local strgmatch = string.gmatch
local Anchors = Anchors



local function isValidAnchorFamily(familyName)
  local targetAnchor = Anchors[familyName]
  if targetAnchor == nil then return false end
  return true
end

local function isValidAnchorFrame(frameName)
  local anchorFamily = _G["anchorFamily"]
  local anchorFrame = anchorFamily[frameName]
  local isValidAnchorFrame = (type(frameName) == "string")
  if isValidAnchorFrame == false then return false end
  return true
end

function TargetFrame_OnLoad(self, unit, menuFunc)
  self.TOT_AURA_ROW_WIDTH = TOT_AURA_ROW_WIDTH;
  TargetFrame_Update(self);
  self:RegisterEvent("PLAYER_ENTERING_WORLD");
  self:RegisterUnitEvent("UNIT_AURA", unit);

end

function TargetFrame_Update (self)
  if ( not UnitExists(self.unit) and not ShowBossFrameWhenUninteractable(self.unit) ) then
		self:Hide();
  else
		self:Show();
    UnitFrame_Update(self);
    TargetFrame_CheckDead(self);
    TargetFrame_UpdateAuras(self);
  end

end

function TargetFrame_OnEvent (self, event, ...)
  UnitFrame_OnEvent(self, event, ...);

	local arg1 = ...;
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		TargetFrame_Update(self);
	elseif ( event == "PLAYER_TARGET_CHANGED" ) then
		-- Moved here to avoid taint from functions below
		TargetFrame_Update(self);
	elseif ( event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" ) then
		for i = 1, MAX_BOSS_FRAMES do
			TargetFrame_Update(_G["Boss"..i.."TargetFrame"]);
    end
	elseif ( event == "UNIT_AURA" ) then
		if ( arg1 == self.unit ) then
			TargetFrame_UpdateAuras(self);
		end
	elseif ( event == "GROUP_ROSTER_UPDATE" ) then
		TargetFrame_Update(self);
	elseif ( event == "PLAYER_FOCUS_CHANGED" ) then
		if ( UnitExists(self.unit) ) then
			self:Show();
			TargetFrame_Update(self);
    end
	end
end



-- function Aura:CreateFrame()
-- 	self.frame = CreateFrame("Button", self.name, self, "TargetBuffFrameTemplate")
-- end


function TargetFrame_UpdateAuras (self)
	local frame, frameName;
	local frameIcon, frameCount, frameCooldown;
	local numBuffs = 0;
	local playerIsTarget = UnitIsUnit(PlayerFrame.unit, self.unit);
	local selfName = self:GetName();
	local canAssist = UnitCanAssist("player", self.unit);

	for i = 1, MAX_TARGET_BUFFS do
		local buffName, icon, count, _, duration, expirationTime, caster, canStealOrPurge, _ , spellId, _, _, casterIsPlayer, nameplateShowAll
			= UnitBuff(self.unit, i, nil);
		if (buffName) then
			frameName = selfName .. "Buff" .. (i);
			frame = _G[frameName];
			if ( not frame ) then
				if ( not icon ) then
					break;
				else
					frame = CreateFrame("Button", frameName, self, "TargetBuffFrameTemplate");
					frame.unit = self.unit;
				end
			end
			if ( icon and ( not self.maxBuffs or i <= self.maxBuffs ) ) then
				frame:SetID(i);

				-- set the icon
				frameIcon = _G[frameName .. "Icon"];
				frameIcon:SetTexture(icon);

				-- set the count
				frameCount = _G[frameName .. "Count"];
				if ( count > 1 and self.showAuraCount ) then
					frameCount:SetText(count);
					frameCount:Show();
				else
					frameCount:Hide();
				end

				-- Handle cooldowns
				frameCooldown = _G[frameName .. "Cooldown"];
				CooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);

				-- Show stealable frame if the target is not the current player and the buff is stealable.
				local frameStealable = _G[frameName .. "Stealable"];
				if ( not playerIsTarget and canStealOrPurge ) then
						frameStealable:Show();
				else
						frameStealable:Hide();
				end

				numBuffs = numBuffs + 1;
				largeBuffList[numBuffs] = ShouldAuraBeLarge(caster);

				frame:ClearAllPoints();
				frame:Show();
				else
					frame:Hide();
				end
		else
				break;
		end
	end

	for i = numBuffs + 1, MAX_TARGET_BUFFS do
		local frame = _G[selfName .. "Buff" .. i];
		if ( frame ) then
			frame:Hide();
		else
			break;
		end
	end

	local color;
	local frameBorder;
	local numDebuffs = 0;

	local frameNum = 1;
	local index = 1;

	local maxDebuffs = self.maxDebuffs or MAX_TARGET_DEBUFFS;
	while ( frameNum <= maxDebuffs and index <= maxDebuffs ) do
		local debuffName, icon, count, debuffType, duration, expirationTime, caster, _, _, _, _, _, casterIsPlayer, nameplateShowAll = UnitDebuff(self.unit, index, "INCLUDE_NAME_PLATE_ONLY");
		if ( debuffName ) then
			if ( TargetFrame_ShouldShowDebuffs(self.unit, caster, nameplateShowAll, casterIsPlayer) ) then
				frameName = selfName .. "Debuff" .. frameNum;
				frame = _G[frameName];
				if ( icon ) then
					if ( not frame ) then
						frame = CreateFrame("Button", frameName, self, "TargetDebuffFrameTemplate");
						frame.unit = self.unit;
					end
					frame:SetID(index);

					-- set the icon
					frameIcon = _G[frameName .. "Icon"];
					frameIcon:SetTexture(icon);

					-- set the count
					frameCount = _G[frameName .. "Count"];
					if ( count > 1 and self.showAuraCount ) then
						frameCount:SetText(count);
						frameCount:Show();
					else
						frameCount:Hide();
					end

					-- Handle cooldowns
					frameCooldown = _G[frameName .. "Cooldown"];
					CooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);

					-- set debuff type color
					if ( debuffType ) then
						color = DebuffTypeColor[debuffType];
					else
						color = DebuffTypeColor["none"];
					end
					frameBorder = _G[frameName .. "Border"];
					frameBorder:SetVertexColor(color.r, color.g, color.b);

					-- set the debuff to be big if the buff is cast by the player or his pet
					numDebuffs = numDebuffs + 1;
					largeDebuffList[numDebuffs] = ShouldAuraBeLarge(caster);

					frame:ClearAllPoints();
					frame:Show();

					frameNum = frameNum + 1;
				end
			end
		else
			break;
		end
		index = index + 1;
	end

	for i = frameNum, MAX_TARGET_DEBUFFS do
		local frame = _G[selfName .. "Debuff" .. i];
		if ( frame ) then
			frame:Hide();
		else
			break;
		end
	end

	self.auraRows = 0;

	local mirrorAurasVertically = false;
	if ( self.buffsOnTop ) then
		mirrorAurasVertically = true;
	end
	local haveTargetofTarget;
	if ( self.totFrame ) then
		haveTargetofTarget = self.totFrame:IsShown();
	end
	self.spellbarAnchor = nil;
	local maxRowWidth;
	-- update buff positions
	maxRowWidth = ( haveTargetofTarget and self.TOT_AURA_ROW_WIDTH ) or AURA_ROW_WIDTH;
	TargetFrame_UpdateAuraPositions(self, selfName .. "Buff", numBuffs, numDebuffs, largeBuffList, TargetFrame_UpdateBuffAnchor, maxRowWidth, 3, mirrorAurasVertically);
	-- update debuff positions
	maxRowWidth = ( haveTargetofTarget and self.auraRows < NUM_TOT_AURA_ROWS and self.TOT_AURA_ROW_WIDTH ) or AURA_ROW_WIDTH;
	TargetFrame_UpdateAuraPositions(self, selfName .. "Debuff", numDebuffs, numBuffs, largeDebuffList, TargetFrame_UpdateDebuffAnchor, maxRowWidth, 3, mirrorAurasVertically);
	-- update the spell bar position
	if ( self.spellbar ) then
		Target_Spellbar_AdjustPosition(self.spellbar);
	end
end



local function createIcon()
  local button = group.buttons[id]
	if( not button ) then
		group.buttons[id] = CreateFrame("Button", nil, group)

	-- 	button = group.buttons[id]
	-- 	button:SetScript("OnEnter", showTooltip)
	-- 	button:SetScript("OnLeave", hideTooltip)
	-- 	button:RegisterForClicks("RightButtonUp")

	-- 	button.cooldown = CreateFrame("Cooldown", group.parent:GetName() .. "Aura" .. group.type .. id .. "Cooldown", button, "CooldownFrameTemplate")
	-- 	button.cooldown:SetAllPoints(button)
	-- 	button.cooldown:SetReverse(true)
	-- 	button.cooldown:SetDrawEdge(false)
	-- 	button.cooldown:SetDrawSwipe(true)
	-- 	button.cooldown:SetSwipeColor(0, 0, 0, 0.8)
	-- 	button.cooldown:Hide()

	-- 	button.stack = button:CreateFontString(nil, "OVERLAY")
	-- 	button.stack:SetFont("Interface\\AddOns\\ShadowedUnitFrames\\media\\fonts\\Myriad Condensed Web.ttf", 10, "OUTLINE")
	-- 	button.stack:SetShadowColor(0, 0, 0, 1.0)
	-- 	button.stack:SetShadowOffset(0.50, -0.50)
	-- 	button.stack:SetHeight(1)
	-- 	button.stack:SetWidth(1)
	-- 	button.stack:SetAllPoints(button)
	-- 	button.stack:SetJustifyV("BOTTOM")
	-- 	button.stack:SetJustifyH("RIGHT")

	-- 	button.border = button:CreateTexture(nil, "OVERLAY")
	-- 	button.border:SetPoint("CENTER", button)

	-- 	button.icon = button:CreateTexture(nil, "BACKGROUND")
	-- 	button.icon:SetAllPoints(button)
	-- 	button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	-- end

	-- if( ShadowUF.db.profile.auras.borderType == "" ) then
	-- 	button.border:Hide()
	-- elseif( ShadowUF.db.profile.auras.borderType == "blizzard" ) then
	-- 	button.border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
	-- 	button.border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
	-- 	button.border:Show()
	-- else
	-- 	button.border:SetTexture("Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\border-" .. ShadowUF.db.profile.auras.borderType)
	-- 	button.border:SetTexCoord(0, 1, 0, 1)
	-- 	button.border:Show()
	-- end

	-- -- Set the button sizing
	-- button.cooldown.noCooldownCount = ShadowUF.db.profile.omnicc
	-- button.cooldown:SetHideCountdownNumbers(ShadowUF.db.profile.blizzardcc)
	-- button:SetHeight(config.size)
	-- button:SetWidth(config.size)
	-- button.border:SetHeight(config.size + 1)
	-- button.border:SetWidth(config.size + 1)
	-- button.stack:SetFont("Interface\\AddOns\\ShadowedUnitFrames\\media\\fonts\\Myriad Condensed Web.ttf", math.floor((config.size * 0.60) + 0.5), "OUTLINE")

	-- button:SetScript("OnClick", cancelAura)
	-- button.parent = group.parent
	-- button:ClearAllPoints()
	-- button:Hide()

	-- -- Position the button quickly
	-- positionButton(id, group, config)
end

